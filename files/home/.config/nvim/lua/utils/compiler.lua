local M = {}

local info = require("utils.info")
local fs = require("utils.fs")

M.cache_dir = info.path.stdpath("cache") .. "/compiled/"
M.mem_cache = {}
M.manifest_path = M.cache_dir .. "manifest.msgpack"
M.manifest = nil


function M.compile(path)
    local chunk, _ = loadfile(path)
    if chunk then return string.dump(chunk, true) end
    return nil
end

function M.compile_value(value)
    return string.dump(function() return value end, true)
end

function M.compile_table(value)
    local source_code = "return " .. vim.inspect(value)
    local chunk = load(source_code)

    if not chunk then return nil end

    local bytecode = string.dump(chunk, true)
    return bytecode
end

function M.load(path)
    local ok, val = pcall(dofile, path)
    if ok then return val end
    return nil
end

function M.cached_require(path)
    local cached = M.mem_cache[path]
    if cached then return cached.result end

    local cache_dir = M.cache_dir
    local cache_path = fs.join(cache_dir, (path:gsub("%.lua$", ".luac")))

    local src_mtime = fs.mtime(path)
    if not src_mtime then return nil end

    local cache_mtime = fs.mtime(cache_path)

    if not cache_mtime or src_mtime > cache_mtime then
        local bytecode = M.compile(path)
        if not bytecode then return nil end

        local ok = fs.write(cache_path, bytecode)
        if not ok then return nil end
    end

    M.mem_cache[path] = { result = M.load(cache_path) }
    return M.mem_cache[path].result
end

function M.load_manifest()
    if M.manifest then return M.manifest end
    if not fs.exists(M.manifest_path) then
        M.manifest = {}
        M.save_manifest()
        return M.manifest
    end
    local data = fs.read(M.manifest_path)
    if data then
        local ok, result = pcall(vim.mpack.decode, data)
        M.manifest = (ok and type(result) == "table") and result or {}
    else
        M.manifest = {}
    end
    return M.manifest
end

function M.save_manifest()
    local ok, encoded = pcall(vim.mpack.encode, M.manifest)
    if not ok then return false end
    local ok2 = fs.write(M.manifest_path, encoded)
    if not ok2 then return false end
    return true
end

function M.manifest_require(path)
    local cached = M.mem_cache[path]
    if cached then return cached.result end

    local manifest = M.load_manifest()

    local src = fs.read(path)
    if not src then return nil end

    local hash = vim.fn.sha256(src)
    local cache_path = fs.join(M.cache_dir, (path:gsub("%.lua$", ".luac")))

    if manifest[path] ~= hash or not fs.exists(cache_path) then
        local bytecode = M.compile(path)
        if not bytecode then return nil end

        local ok = fs.write(cache_path, bytecode)
        if not ok then return nil end

        manifest[path] = hash
        M.save_manifest()
    end

    M.mem_cache[path] = { result = M.load(cache_path) }
    return M.mem_cache[path].result
end

return M
