require "core.ui.statusline.highlights"
require "core.ui.statusline.format"


vim.opt.ruler = false
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"

vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.showcmdloc = 'statusline'

vim.opt.cmdheight = 0

vim.opt.laststatus = 2
vim.opt.statusline = "%!v:lua.StatusLine()"
