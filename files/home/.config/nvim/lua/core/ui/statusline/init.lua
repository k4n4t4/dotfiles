require "core.ui.statusline.highlights"
require "core.ui.statusline.format"


vim.opt.ruler = false
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"

vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.showcmdloc = 'statusline'

vim.opt.cmdheight = 0
vim.opt.cmdwinheight = 10

vim.opt.laststatus = 3
vim.opt.statusline = "%{% v:lua.StatusLine(g:actual_curwin == win_getid()) %}"
