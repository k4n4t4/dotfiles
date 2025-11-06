require "core.ui.statusline.highlights"
require "core.ui.statusline.format"

vim.opt.ruler = false
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"

vim.opt.laststatus = 3
vim.opt.statusline = "%{% v:lua.StatusLine(g:actual_curwin == win_getid()) %}"
