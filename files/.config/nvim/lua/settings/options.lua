vim.opt.encoding     = "utf-8"
vim.scriptencoding   = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = { "utf-8", "sjis" }
vim.opt.fileformats   = { "unix", "dos" }


vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 3
vim.opt.signcolumn = "yes"

vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"
vim.opt.cursorcolumn = false

vim.opt.winblend = 20
vim.opt.pumblend = 20

vim.opt.list = true
vim.opt.listchars = {
  tab      = ">-",
  extends  = ">",
  precedes = "<",
  trail    = "-",
  nbsp     = "+",
  conceal  = "@",
}
vim.opt.fillchars = {
  eob = " ",
  fold = "·",
  foldopen = "v",
  foldsep = "¦",
  foldclose = ">",
}

vim.opt.ambiwidth = "single"

vim.opt.wrap = true
vim.opt.display = "lastline"
vim.opt.breakat = " ^I!@*-+;:,./?"
vim.opt.linebreak = false
vim.opt.breakindent = false
vim.opt.showbreak = ""

vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"

vim.opt.cmdheight = 0
vim.opt.cmdwinheight = 10

vim.opt.pumheight = 10

vim.opt.scroll = 10
vim.opt.scrolloff = 3
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 3

vim.opt.laststatus = 2
vim.opt.showmode = false
vim.opt.showcmd = true
vim.opt.showcmdloc = 'statusline'
vim.opt.showtabline = 1

vim.opt.ruler = false
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"

vim.opt.spell = false
vim.opt.spelllang = "en"

vim.opt.foldenable = true
vim.opt.foldcolumn = '1'
vim.opt.foldmethod = "manual"
vim.opt.foldmarker = "{{{,}}}"

vim.opt.belloff = "all"
vim.opt.visualbell = true
vim.opt.errorbells = false

vim.opt.shortmess:append 'I'

vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true


vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"


vim.opt.directory = vim.fn.stdpath("data") .. "/swap"
vim.opt.undodir   = vim.fn.stdpath("data") .. "/undo"
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"

vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup   = false
vim.opt.writebackup = false
vim.opt.backupext = ".bak"


vim.opt.mouse = ""
vim.opt.title = true
vim.opt.clipboard:append "unnamedplus"

vim.opt.autoread = true

vim.opt.hidden = true

vim.opt.confirm = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.virtualedit = "block"

vim.opt.gdefault = false

vim.opt.whichwrap = "b,s,h,l,~,<,>,[,]"

vim.opt.backspace = { "indent", "eol", "nostop" }

vim.opt.nrformats = { "bin", "octal", "hex" }

vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

vim.opt.completeopt = { "menuone", "preview" }

vim.opt.viewoptions = { "folds", "cursor", "curdir" }


vim.opt.termguicolors = true
vim.opt.background = "dark"
