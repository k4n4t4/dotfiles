vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.signcolumn = "yes"
vim.opt.list = true
vim.opt.listchars = {tab = ">-", trail = "-", nbsp = "+"}
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.visualbell = true

vim.ambiwidth = "single"
vim.opt.wrap = true

vim.opt.mouse = "a"
vim.opt.title = true
vim.opt.clipboard:append "unnamedplus"

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.showcmd = true
vim.opt.showmatch = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.hidden = true

vim.opt.backspace = [[indent,eol,start]]
vim.opt.splitright = true
vim.opt.confirm = true
vim.opt.wildmenu = true

vim.opt.cmdheight = 1
vim.opt.laststatus = 3
vim.opt.showtabline = 2

vim.opt.winblend = 20
vim.opt.pumblend = 20
vim.opt.termguicolors=true
vim.opt.background = "dark"
vim.cmd "colorscheme onedark"
vim.cmd "hi Normal guibg = None"

