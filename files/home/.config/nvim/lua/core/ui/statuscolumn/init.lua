require "core.ui.statuscolumn.highlights"
require "core.ui.statuscolumn.format"

vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.statuscolumn = "%!v:lua.StatusColumn()"
