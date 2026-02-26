--- Utility to compile Lua files into LuaJIT bytecode and cache them on disk.
--- Loading bytecode directly via dofile is faster than require at startup.

local M = {}

--- Returns true if the cache is stale.
--- Stale when the manifest is missing, the entry count changed, or any source is newer.
---@param cache_dir string cache directory (trailing `/` required)
---@param entries { src: string, key: string }[]
---@return boolean
function M.is_stale(cache_dir, entries)
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
---@param entries { src: string, key: string }[]
---@return string[] list of successfully compiled keys
function M.compile(cache_dir, entries)
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
---@param entries { src: string, key: string }[]
---@return any[] | nil
function M.load(cache_dir, entries)
    if M.is_stale(cache_dir, entries) then
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

return M
