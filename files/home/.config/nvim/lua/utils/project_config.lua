local M = {}

function M.get_project_config_path(cwd)
    local cwd_str = require("utils.fs").path_to_percent(cwd)
    return M.project_cache_dir .. "/" .. cwd_str .. ".lua"
end

function M.load_project_config(path)
    if vim.fn.filereadable(path) == 1 then
        dofile(path)
    end
end

function M.edit_project_config(path)
    vim.cmd("edit " .. path)
    vim.api.nvim_create_autocmd("BufWritePost", {
        buffer = vim.api.nvim_get_current_buf(),
        once = true,
        callback = function()
            M.load_project_config(path)
        end,
    })
end

function M.setup()
    M.project_cache_dir = vim.fn.stdpath("cache") .. "/project_configs"

    if vim.fn.isdirectory(M.project_cache_dir) == 0 then
        vim.fn.mkdir(M.project_cache_dir, "p")
    end

    vim.api.nvim_create_user_command("EditConfig", function()
        local path = M.get_project_config_path(vim.fn.getcwd())
        M.edit_project_config(path)
    end, {})
end

return M
