require "core.ui.statuscolumn.highlights"
require "core.ui.statuscolumn.format"


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.numberwidth = 4

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.cursorcolumn = false
vim.opt.colorcolumn = { 80, 160 }

vim.opt.foldcolumn = "0"
vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"
