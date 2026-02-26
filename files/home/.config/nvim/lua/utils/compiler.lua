local M = {}

local fs = require("utils.fs")

M.cache_dir = vim.fn.stdpath("cache") .. "/compiled/"
M.mem_cahce = {}

function M.compile(path)
    local chunk, err = loadfile(path)
    if chunk then return string.dump(chunk, true) end
    vim.notify("[compiler] compile error: " .. tostring(err), vim.log.levels.WARN)
    return nil
end

function M.compile_value(value)
    return string.dump(function() return value end, true)
end

function M.load(path)
    local ok, val = pcall(dofile, path)
    if ok then return val end
    vim.notify("[compiler] load error: " .. tostring(val), vim.log.levels.WARN)
    return nil
end

function M.cached_require(path)
    local cached = M.mem_cahce[path]
    if cached then return cached.result end

    local cache_dir = M.cache_dir
    local cache_path = fs.join(cache_dir, (path:gsub("%.lua$", ".luac")))

    local src_mtime = fs.mtime(path)
    if not src_mtime then
        vim.notify("[compiler] source not found: " .. path, vim.log.levels.WARN)
        return nil
    end

    local cache_mtime = fs.mtime(cache_path)

    if not cache_mtime or src_mtime > cache_mtime then
        local bytecode = M.compile(path)
        if not bytecode then return nil end

        local ok = fs.write(cache_path, bytecode)
        if not ok then
            vim.notify("[compiler] failed to write cache: " .. cache_path, vim.log.levels.WARN)
            return nil
        end
    end

    M.mem_cahce[path] = { result = M.load(cache_path) }
    return M.mem_cahce[path].result
end

return M
