local M = {}

M.group_name = "toggle_relative_number"
M.group = vim.api.nvim_create_augroup(M.group_name, { clear = true })
local autocmd = vim.api.nvim_create_autocmd

function M.enable()
    vim.api.nvim_clear_autocmds({ group = M.group_name })

    -- toggle relativenumber when enter insert mode
    autocmd("InsertEnter", {
        group = M.group;
        callback = function()
            if vim.opt_local.number:get() then
                vim.opt_local.relativenumber = false
            end
        end;
    })

    autocmd("InsertLeave", {
        group = M.group;
        callback = function()
            if vim.opt_local.number:get() then
                vim.opt_local.relativenumber = true
            end
        end;
    })
end

function M.disable()
    vim.api.nvim_clear_autocmds({ group = M.group_name })
end

return M
