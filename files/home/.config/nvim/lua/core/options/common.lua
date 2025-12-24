vim.opt.debug = 'throw'

vim.opt.encoding     = "utf-8"
vim.scriptencoding   = "utf-8"
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = {
  "utf-8",
  "utf-16",
  "ucs2le",
  "ucs-2",
  "iso-2022-jp",
  "euc-jp",
  "sjis",
  "cp932",
  "latin1",
  "default",
}

vim.opt.fileformat = "unix"
vim.opt.fileformats = { "unix", "dos", "mac" }

vim.opt.history = 1000

vim.opt.title = true
vim.opt.mouse = "a"
vim.opt.clipboard:append "unnamedplus"

vim.opt.shortmess:append 'I'

vim.opt.termguicolors = true
vim.opt.background = "dark"


vim.opt.ambiwidth = "single"

vim.opt.synmaxcol = 1000

vim.opt.belloff = ""
vim.opt.visualbell = true
vim.opt.errorbells = false

vim.opt.cmdwinheight = 10

vim.opt.winblend = 20
vim.opt.pumblend = 20

vim.opt.pumheight = 10
vim.opt.pumwidth = 10

vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.scroll = 10
vim.opt.scrolloff = 3
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 3

vim.opt.wrap = true
vim.opt.display = "lastline"
vim.opt.breakat = " ^I!@*-+;:,./?"
vim.opt.linebreak = false
vim.opt.breakindent = true
vim.opt.showbreak = ""

-- match
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.startofline = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = false
vim.opt.inccommand = "split"
vim.opt.magic = true

vim.opt.autoread = true
vim.opt.hidden = true
vim.opt.confirm = true

vim.opt.virtualedit = "block"


vim.opt.whichwrap = "b,s,~,<,>,[,]"
vim.opt.backspace = { "indent", "eol", "nostop" }
vim.opt.nrformats = { "bin", "octal", "hex" }


vim.opt.completeopt = {
  "menu",
  "menuone",
  "preview",
  "noselect"
}

vim.opt.viewoptions = {
  "folds",
  "cursor",
  "localoptions"
}

vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupext = ".bak"

vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"


vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true


vim.opt.spell = false
vim.opt.spelllang = { "en", "cjk" }


vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"
