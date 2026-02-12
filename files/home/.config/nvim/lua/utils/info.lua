local M = {}

local group = vim.api.nvim_create_augroup("Utils_info", { clear = true })
local uv = vim.uv or vim.loop


M.cache = {}
local function cached(key, fn)
    if M.cache[key] == nil then
        M.cache[key] = fn()
    end
    return M.cache[key]
end

local function file_exists(path)
    return uv.fs_stat(path) ~= nil
end

local function path_contains(path, target)
    if not path or not target then return false end
    return string.find(path, target, 1, true) ~= nil
end


M.path = {}

function M.path.cwd()
    return cached("path_cwd", uv.cwd)
end

function M.path.config()
    return cached("path_config", function()
        return vim.fn.stdpath("config")
    end)
end

function M.path.in_config_dir()
    return cached("path_in_config_dir", function()
        return path_contains(M.path.cwd(), M.path.config())
    end)
end

function M.path.in_nvim_repo()
    return cached("path_in_nvim_repo", function()
        return path_contains(M.path.cwd(), "/nvim")
    end)
end

function M.path.is_nvim_related()
    return cached("path_is_nvim_related", function()
        return M.path.in_config_dir() or M.path.in_nvim_repo()
    end)
end


M.env = {}

function M.env.os_name()
    return cached("env_os_name", function()
        return vim.loop.os_uname().sysname
    end)
end

function M.env.is_linux()
    return cached("env_is_linux", function()
        return M.env.os_name() == "Linux"
    end)
end

function M.env.is_nixos()
    return cached("env_is_nixos", function()
        return file_exists("/etc/NIXOS")
            or file_exists("/run/current-system")
    end)
end

function M.env.is_docker()
    return cached("env_is_docker", function()
        return file_exists("/.dockerenv")
            or path_contains(vim.env.container, "docker")
    end)
end

function M.env.is_wsl()
    return cached("env_is_wsl", function()
        return vim.env.WSL_DISTRO_NAME ~= nil
    end)
end

function M.env.is_vscode()
    return cached("env_is_vscode", function()
        return vim.g.vscode == 1
    end)
end


M.buf = {}
M.buf.cache = {}

vim.api.nvim_create_autocmd("BufDelete", {
    group = group;
    callback = function(args)
        M.buf.cache[args.buf] = nil
    end;
})

local function cached_buf(bufnr, key, fn)
    bufnr = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if not vim.api.nvim_buf_is_valid(bufnr) then return nil end

    if not M.buf.cache[bufnr] then M.buf.cache[bufnr] = {} end
    if M.buf.cache[bufnr][key] == nil then
        M.buf.cache[bufnr][key] = fn(bufnr)
    end
    return M.buf.cache[bufnr][key]
end

function M.buf.get_opt(bufnr, name)
    return vim.api.nvim_get_option_value(name, { buf = bufnr })
end

function M.buf.name(bufnr)
    return cached_buf(bufnr, "name", function(b)
        local path = vim.api.nvim_buf_get_name(b)
        return path ~= "" and vim.fn.fnamemodify(path, ":t") or "[No Name]"
    end)
end

function M.buf.path(bufnr)
    return cached_buf(bufnr, "path", function(b)
        return vim.api.nvim_buf_get_name(b)
    end)
end

function M.buf.filetype(bufnr)
    return cached_buf(bufnr, "filetype", function(b)
        return M.buf.get_opt(b, "filetype")
    end)
end

function M.buf.modified(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    return vim.api.nvim_buf_is_valid(b) and M.buf.get_opt(b, "modified") or false
end

return M
