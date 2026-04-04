local M = {}

M.group = vim.api.nvim_create_augroup("StatusColumn", { clear = true })

function M.setup()
    require "utils.statuscolumn.highlights"

    vim.opt.signcolumn = "yes"
    vim.opt.cursorline = true
    vim.opt.cursorlineopt = "number"
    vim.opt.statuscolumn = "%!v:lua.require('utils.statuscolumn.format')()"

    vim.api.nvim_create_autocmd("BufEnter", {
        group = M.group,
        callback = function()
            if vim.fn.getcmdwintype() ~= "" then
                vim.opt_local.foldcolumn = '0'
                vim.opt_local.signcolumn = "no"
            end
        end,
    })
end

return M
