local M = {}

local uv = vim.uv or vim.loop

--- Converts a dot-separated module path to a filesystem path (replaces '.' with '/').
--- @param path string Dot-separated path (e.g. "foo.bar.baz")
--- @return string Filesystem path (e.g. "foo/bar/baz")
function M.to_path(path)
    return (path:gsub("%.", "/"))
end

--- Converts a filesystem path to a dot-separated module path (replaces '/' with '.').
--- @param path string Filesystem path (e.g. "foo/bar/baz")
--- @return string Dot-separated path (e.g. "foo.bar.baz")
function M.to_dot(path)
    return (path:gsub("/", "."))
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

--- Joins path segments with '/'.
--- @param ... string Path segments
--- @return string
function M.join(...)
    local parts = { ... }
    local result = table.concat(parts, "/")
    -- collapse multiple consecutive slashes (except leading //)
    result = result:gsub("([^/])/+", "%1/"):gsub("^//+", "//")
    return result
end

--- Returns true if the path exists (file or directory).
--- @param path string
--- @return boolean
function M.exists(path)
    return uv.fs_stat(path) ~= nil
end

--- Returns the modification time (seconds since epoch) of a path, or nil if it does not exist.
--- @param path string
--- @return number|nil
function M.mtime(path)
    local stat = uv.fs_stat(path)
    return stat and stat.mtime.sec or nil
end

--- Creates directories recursively (like mkdir -p).
--- @param path string Absolute path to create
--- @return boolean success
function M.mkdir_p(path)
    if M.exists(path) then return true end
    local parent = M.get_dirname(path)
    if parent and parent ~= path then
        if not M.mkdir_p(parent) then return false end
    end
    return uv.fs_mkdir(path, 493) ~= nil -- 493 = 0755
end

--- Reads the entire contents of a file.
--- @param path string
--- @return string|nil
function M.read(path)
    local fd = uv.fs_open(path, "r", 438)
    if not fd then return nil end
    local stat = uv.fs_fstat(fd)
    if not stat then uv.fs_close(fd); return nil end
    local data = uv.fs_read(fd, stat.size, 0)
    uv.fs_close(fd)
    return data
end

--- Writes data to a file, creating parent directories as needed.
--- @param path string
--- @param data string
--- @return boolean success
function M.write(path, data)
    local dir = M.get_dirname(path)
    if dir then M.mkdir_p(dir) end
    local fd = uv.fs_open(path, "w", 438) -- 438 = 0644
    if not fd then return false end
    uv.fs_write(fd, data, 0)
    uv.fs_close(fd)
    return true
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
