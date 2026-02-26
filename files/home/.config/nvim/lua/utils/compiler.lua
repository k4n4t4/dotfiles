local M = {}

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

return M
