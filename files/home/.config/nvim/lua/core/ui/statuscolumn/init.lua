require "core.ui.statuscolumn.highlights"
require "core.ui.statuscolumn.format"

vim.opt.foldcolumn = "0"
vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"
