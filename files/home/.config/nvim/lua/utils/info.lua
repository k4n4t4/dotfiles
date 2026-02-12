local M = {}

local uv = vim.uv or vim.loop


local cache = {}
local function cached(key, fn)
    if cache[key] == nil then
        cache[key] = fn()
    end
    return cache[key]
end

local function file_exists(path)
    return uv.fs_stat(path) ~= nil
end

local function path_contains(path, target)
    if not path or not target then return false end
    return string.find(path, target, 1, true) ~= nil
end

function M.reset()
    cache = {}
end

function M.dump()
    return vim.deepcopy(cache)
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


return M
