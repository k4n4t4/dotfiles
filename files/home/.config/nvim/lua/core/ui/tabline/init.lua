require "core.ui.tabline.autocmds"
require "core.ui.tabline.highlights"
require "core.ui.tabline.format"

vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.TabLine()"
