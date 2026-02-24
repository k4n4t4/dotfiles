local M = {}

M.group = vim.api.nvim_create_augroup("Tabline", { clear = true })

M.min_tabs = 0
M.show_tabline = true

function M.show()
    vim.opt.showtabline = 2
end

function M.hide()
    vim.opt.showtabline = 0
end

function M.setup(opts)
    opts = opts or {}
    M.show_tabline = opts.show_tabline or M.show_tabline
    if not M.show_tabline then return end

    M.min_tabs = opts.min_tabs or M.min_tabs

    require "utils.tabuf".setup()
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
