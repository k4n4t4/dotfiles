require "core.ui.statusline.highlights"
require "core.ui.statusline.format"


vim.opt.showcmdloc = 'statusline'
vim.opt.cmdheight = 0
-- vim.opt.laststatus = 3
vim.opt.laststatus = 2 -- DEBUG:
vim.opt.statusline = "%!v:lua.StatusLine()"
