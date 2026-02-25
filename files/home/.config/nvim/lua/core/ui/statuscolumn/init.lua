local M = {}

function M.setup()
    require "core.ui.statuscolumn.highlights"

    vim.opt.signcolumn = "yes"
    vim.opt.cursorline = true
    vim.opt.cursorlineopt = "number"
    vim.opt.tabline = "%!v:lua.require('core.ui.statuscolumn.format')()"
end

M.setup()

return M
