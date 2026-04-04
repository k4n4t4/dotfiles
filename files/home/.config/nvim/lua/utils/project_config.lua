local M = {}

function M.get_path(cwd)
    local cwd_str = require("utils.fs").path_to_percent(cwd)
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

function M.setup()
    M.project_cache_dir = vim.fn.stdpath("cache") .. "/utils/project_configs"

    if vim.fn.isdirectory(M.project_cache_dir) == 0 then
        vim.fn.mkdir(M.project_cache_dir, "p")
    end

    local path = M.get_path(vim.fn.getcwd())
    M.load(path)

    vim.api.nvim_create_user_command("EditConfig", function()
        local config_path = M.get_path(vim.fn.getcwd())
        M.edit(config_path)
    end, {})
end

return M
