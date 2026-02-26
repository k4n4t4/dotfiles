local M = {}

--- Builds an entries list from a file path or directory path.
--- For a directory, collects all .lua files inside (non-recursive).
--- For a single file, wraps it in a single-element list.
---@param file string path to a .lua file or directory
---@return { src: string, key: string }[]
function M.entries_from(file)
    file = file:gsub("/$", "")
    local stat = vim.uv.fs_stat(file)
    if not stat then return {} end
    if stat.type == "directory" then
        local entries = {}
        local handle = vim.uv.fs_scandir(file)
        if handle then
            while true do
                local name, ftype = vim.uv.fs_scandir_next(handle)
                if not name then break end
                if name:match("%.lua$") and ftype ~= "directory" then
                    table.insert(entries, {
                        src = file .. "/" .. name,
                        key = name:gsub("%.lua$", "") .. ".luac",
                    })
                end
            end
        end
        return entries
    else
        local name = file:match("([^/]+)$") or file
        return { { src = file, key = name:gsub("%.lua$", "") .. ".luac" } }
    end
end

--- Resolves a file/dir path or entries table into an entries list.
---@param file_or_entries string | { src: string, key: string }[]
---@return { src: string, key: string }[]
local function resolve(file_or_entries)
    if type(file_or_entries) == "string" then
        return M.entries_from(file_or_entries)
    end
    return file_or_entries
end

--- Returns true if the cache is stale.
--- Stale when the manifest is missing, the entry count changed, or any source is newer.
---@param cache_dir string cache directory (trailing `/` required)
---@param entries string | { src: string, key: string }[] file/dir path or entries list
---@return boolean
function M.is_stale(cache_dir, entries)
    entries = resolve(entries)
    local manifest = cache_dir .. "manifest"
    local stat = vim.uv.fs_stat(manifest)
    if not stat then return true end
    local cache_mtime = stat.mtime.sec

    local f = io.open(manifest, "r")
    if not f then return true end
    local count = 0
    for _ in f:lines() do count = count + 1 end
    f:close()
    if count ~= #entries then return true end

    for _, e in ipairs(entries) do
        local s = vim.uv.fs_stat(e.src)
        if s and s.mtime.sec > cache_mtime then return true end
    end
    return false
end

--- Compiles each entry into LuaJIT bytecode and saves it to the cache.
--- `strip=true` removes debug info.
---@param cache_dir string
---@param entries string | { src: string, key: string }[] file/dir path or entries list
---@return string[] list of successfully compiled keys
function M.compile(cache_dir, entries)
    entries = resolve(entries)
    vim.fn.mkdir(cache_dir, "p")
    local keys = {}
    for _, e in ipairs(entries) do
        local chunk, err = loadfile(e.src)
        if chunk then
            local f = io.open(cache_dir .. e.key, "wb")
            if f then
                f:write(string.dump(chunk, true))
                f:close()
                table.insert(keys, e.key)
            end
        else
            vim.notify("[compile] " .. tostring(err), vim.log.levels.WARN)
        end
    end
    local mf = io.open(cache_dir .. "manifest", "w")
    if mf then mf:write(table.concat(keys, "\n")); mf:close() end
    return keys
end

--- Loads each cached file via dofile and returns an array of results.
--- Automatically recompiles if the cache is stale.
--- Returns nil on failure.
---@param cache_dir string
---@param entries string | { src: string, key: string }[] file/dir path or entries list
---@return any[] | nil
function M.load(cache_dir, entries)
    entries = resolve(entries)
    if M.is_stale(cache_dir, entries) then
        vim.notify("[compile] cache stale, recompiling " .. #entries .. " entries", vim.log.levels.INFO)
        M.compile(cache_dir, entries)
    end
    local mf = io.open(cache_dir .. "manifest", "r")
    if not mf then return nil end
    local results = {}
    for key in mf:lines() do
        local ok, val = pcall(dofile, cache_dir .. key)
        if ok then
            table.insert(results, val)
        else
            vim.notify("[compile] load error: " .. tostring(val), vim.log.levels.WARN)
            mf:close()
            return nil
        end
    end
    mf:close()
    return results
end

--- Returns true if the merged cache is stale (missing or any source is newer).
---@param cache_dir string
---@param entries string | { src: string, key: string }[] file/dir path or entries list
---@return boolean
function M.is_merged_stale(cache_dir, entries)
    entries = resolve(entries)
    local stat = vim.uv.fs_stat(cache_dir .. "merged.luac")
    if not stat then return true end
    local mtime = stat.mtime.sec
    for _, e in ipairs(entries) do
        local s = vim.uv.fs_stat(e.src)
        if s and s.mtime.sec > mtime then return true end
    end
    return false
end

--- Combines all spec entries into a single Lua chunk and compiles it to merged.luac.
--- Each spec may return either a single plugin table or an array of plugin tables.
---@param cache_dir string
---@param entries string | { src: string, key: string }[] file/dir path or entries list
---@return boolean success
function M.compile_merged(cache_dir, entries)
    entries = resolve(entries)
    vim.fn.mkdir(cache_dir, "p")
    local parts = { "local _specs = {}\n" }
    for _, e in ipairs(entries) do
        local f = io.open(e.src, "r")
        if f then
            local src = f:read("*a")
            f:close()
            table.insert(parts, "do\n  local function _spec()\n" .. src .. "\n  end\n")
            table.insert(parts, "  local _t = _spec()\n")
            table.insert(parts, "  if type(_t[1]) == 'table' then\n    for _, _i in ipairs(_t) do _specs[#_specs+1] = _i end\n  else\n    _specs[#_specs+1] = _t\n  end\nend\n")
        else
            vim.notify("[compile] cannot read: " .. e.src, vim.log.levels.WARN)
        end
    end
    table.insert(parts, "return _specs\n")
    local chunk, err = load(table.concat(parts), "merged_specs")
    if not chunk then
        vim.notify("[compile] merge error: " .. tostring(err), vim.log.levels.WARN)
        return false
    end
    local f = io.open(cache_dir .. "merged.luac", "wb")
    if not f then
        vim.notify("[compile] cannot write merged.luac", vim.log.levels.WARN)
        return false
    end
    f:write(string.dump(chunk, true))
    f:close()
    return true
end

--- Loads the merged compiled spec, recompiling if stale.
--- Returns a flat array of all plugin specs, or nil on failure.
---@param cache_dir string
---@param entries string | { src: string, key: string }[] file/dir path or entries list
---@return any[] | nil
function M.load_merged(cache_dir, entries)
    entries = resolve(entries)
    if M.is_merged_stale(cache_dir, entries) then
        if not M.compile_merged(cache_dir, entries) then return nil end
    end
    local ok, val = pcall(dofile, cache_dir .. "merged.luac")
    if ok then
        return val
    else
        vim.notify("[compile] load merged error: " .. tostring(val), vim.log.levels.WARN)
        return nil
    end
end

return M
