local M = {}

local uv = vim.uv or vim.loop

function M.to_path(path)
    return path:gsub("%.", "/")
end

function M.to_dot(path)
    return path:gsub("/", ".")
end

function M.get_filename(path)
    return path:match("([^/]+)$")
end

function M.get_extension(path)
    return path:match("%.([^%.]+)$")
end

function M.get_basename(path)
    return path:match("([^/]+)%.?[^%.]*$")
end

function M.get_dirname(path)
    return path:match("(.+)/[^/]+$")
end

function M.scandir(path)
    local files = {}
    local scandir = uv.fs_scandir(path)
    if scandir then
        while true do
            local name = uv.fs_scandir_next(scandir)
            if not name then break end
            table.insert(files, name)
        end
    end
    return files
end

return M
