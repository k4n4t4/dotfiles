local M = {}

local uv = vim.uv or vim.loop

--- Converts a dot-separated module path to a filesystem path (replaces '.' with '/').
--- @param path string Dot-separated path (e.g. "foo.bar.baz")
--- @return string Filesystem path (e.g. "foo/bar/baz")
function M.to_path(path)
    return path:gsub("%.", "/")
end

--- Converts a filesystem path to a dot-separated module path (replaces '/' with '.').
--- @param path string Filesystem path (e.g. "foo/bar/baz")
--- @return string Dot-separated path (e.g. "foo.bar.baz")
function M.to_dot(path)
    return path:gsub("/", ".")
end

--- Returns the filename (last path component) from a path.
--- @param path string
--- @return string|nil
function M.get_filename(path)
    return path:match("([^/]+)$")
end

--- Returns the file extension from a path.
--- @param path string
--- @return string|nil
function M.get_extension(path)
    return path:match("%.([^%.]+)$")
end

--- Returns the basename (filename without extension) from a path.
--- @param path string
--- @return string|nil
function M.get_basename(path)
    return path:match("([^/]+)%.?[^%.]*$")
end

--- Returns the directory component of a path (everything before the last '/').
--- @param path string
--- @return string|nil
function M.get_dirname(path)
    return path:match("(.+)/[^/]+$")
end

--- Scans a directory and returns a list of all filenames in it.
--- @param path string Absolute path to the directory
--- @return string[] List of filenames (not full paths)
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
