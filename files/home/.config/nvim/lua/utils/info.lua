local uv = vim.uv or vim.loop

local M = {}

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

M.path = {}

function M.path.cwd()
    return cached("cwd", uv.cwd)
end

function M.path.config()
    return cached("config", function()
        return vim.fn.stdpath("config")
    end)
end

M.nvim = {}

function M.nvim.in_config_dir()
    return cached("nvim_in_config_dir", function()
        return path_contains(M.path.cwd(), M.path.config())
    end)
end

function M.nvim.in_nvim_repo()
    return cached("nvim_in_repo", function()
        return path_contains(M.path.cwd(), "/nvim")
    end)
end

function M.nvim.is_related()
    return cached("nvim_related", function()
        return M.nvim.in_config_dir() or M.nvim.in_nvim_repo()
    end)
end

M.os = {}

function M.os.name()
    return cached("os_name", function()
        return vim.loop.os_uname().sysname
    end)
end

function M.os.is_linux()
    return cached("os_linux", function()
        return M.os.name() == "Linux"
    end)
end

function M.os.is_nixos()
    return cached("os_nixos", function()
        return file_exists("/etc/NIXOS")
            or file_exists("/run/current-system")
    end)
end

M.env = {}

function M.env.is_docker()
    return cached("env_docker", function()
        return file_exists("/.dockerenv")
            or path_contains(vim.env.container, "docker")
    end)
end

function M.env.is_wsl()
    return cached("env_wsl", function()
        return vim.env.WSL_DISTRO_NAME ~= nil
    end)
end

function M.env.is_vscode()
    return cached("env_vscode", function()
        return vim.g.vscode == 1
    end)
end

M.is = {}

function M.is.nixos() return M.os.is_nixos() end
function M.is.docker() return M.env.is_docker() end
function M.is.wsl() return M.env.is_wsl() end
function M.is.nvim() return M.nvim.is_related() end
function M.is.vscode() return M.env.is_vscode() end

function M.reset()
    cache = {}
end

function M.dump()
    return vim.deepcopy(cache)
end

return M
