local M = {}

M.group = vim.api.nvim_create_augroup("Tabline", { clear = true })

require "utils.tabuf".setup()

M.min_tabs = 0

function M.show()
    vim.opt.showtabline = 2
end

function M.hide()
    vim.opt.showtabline = 0
end

function M.setup()
    require "core.ui.tabline.highlights"

    vim.opt.showtabline = 0
    vim.opt.tabline = "%!v:lua.require('core.ui.tabline.format')()"

    vim.api.nvim_create_autocmd("User", {
        group = M.group,
        pattern = "TabufUpdated",
        callback = function()
            if vim.t.bufs and #vim.t.bufs >= M.min_tabs then
                M.show()
            else
                M.hide()
            end
        end,
    })
end

M.setup()

return M
