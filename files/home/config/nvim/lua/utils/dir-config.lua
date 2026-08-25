local M = {}

M.project_cache_dir = vim.fn.stdpath("cache") .. "/utils/dir-configs"

local function path_to_percent(path)
    return (path:gsub("[/\\:]", "%%"))
end

function M.get_path(cwd)
    local cwd_str = path_to_percent(cwd)
    return M.project_cache_dir .. "/" .. cwd_str .. ".lua"
end

function M.load(path)
    if vim.fn.filereadable(path) == 1 then
        dofile(path)
    end
end

function M.edit(path)
    vim.cmd.edit(vim.fn.fnameescape(path))
end

function M.remove(path)
    if vim.fn.filereadable(path) == 1 then
        vim.fn.delete(path)
    end
end

function M.setup()
    if vim.fn.isdirectory(M.project_cache_dir) == 0 then
        vim.fn.mkdir(M.project_cache_dir, "p")
    end

    local global_config_path = M.get_path("global")
    local config_path = M.get_path(vim.fn.getcwd())

    M.load(global_config_path)
    M.load(config_path)

    vim.api.nvim_create_user_command("EditConfig", function()
        M.edit(config_path)
    end, { desc = "Edit Config" })

    vim.api.nvim_create_user_command("RemoveConfig", function()
        M.remove(config_path)
    end, { desc = "Remove Config" })

    vim.api.nvim_create_user_command("EditGlobalConfig", function()
        M.edit(global_config_path)
    end, { desc = "Edit Global Config" })
end

return M
