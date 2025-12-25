require "core.ui.statuscolumn.highlights"
require "core.ui.statuscolumn.format"


vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

vim.opt.statuscolumn = "%{% g:actual_curwin == win_getid() ? v:lua.StatusColumn() : v:lua.StatusColumnInactive() %}"
