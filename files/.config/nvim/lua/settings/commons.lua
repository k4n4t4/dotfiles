-- encoding --
vim.scriptencoding = "utf-8"
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

-- visual --
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.numberwidth = 4
vim.opt.signcolumn = "yes"

vim.opt.list = true
vim.opt.listchars = {
  tab      = ">-",
  extends  = ">",
  precedes = "<",
  -- space = "･",
  trail    = "-",
  -- lead     = "-",
  -- multispace = "---+",
  -- leadmultispace = "---+",
  nbsp     = "+",
  conceal  = "@",
  -- eol = "$",
}

vim.opt.ambiwidth = "single"

vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.cursorlineopt = "number"

-- status --
vim.opt.ruler = true
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"
vim.opt.statusline = "%<%f%h%m%r%=%B %l,%c%V %P"

vim.opt.display = "lastline"

vim.opt.wrap = true
vim.opt.breakat = " ^I!@*-+;:,./?"
vim.opt.linebreak = false
vim.opt.breakindent = false
vim.opt.showbreak = ""

vim.opt.cmdheight = 1
vim.opt.cmdwinheight = 10

vim.opt.laststatus = 3
vim.opt.showmode = true
vim.opt.showcmd = true
vim.opt.showtabline = 2


vim.opt.spell = true
vim.opt.spelllang = "en"

vim.opt.foldenable = true
vim.opt.foldmethod = "manual"
vim.opt.foldmarker = "{{{,}}}"

vim.opt.belloff = "all"
vim.opt.visualbell = true

-- edit --
vim.opt.mouse = ""
vim.opt.title = true
vim.opt.clipboard:append "unnamedplus"

-- indent --
vim.opt.smarttab = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.smartindent = true
vim.opt.autoindent = true

-- search --
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.wrapscan = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.gdefault = false

vim.opt.inccommand = "split"

vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.matchpairs = {
  "(:)",
  "{:}",
  "[:]",
  "<:>",
}

vim.opt.nrformats = {
  "bin",
  "octal",
  "hex",
}

vim.opt.virtualedit = "block"

vim.opt.autoread = true
vim.opt.directory = vim.fn.stdpath("data") .. "/swap"
vim.opt.backupdir = vim.fn.stdpath("data") .. "/backup"
vim.opt.undodir   = vim.fn.stdpath("data") .. "/undo"
vim.opt.swapfile = false
vim.opt.undofile = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.backupext = ".bak"
vim.opt.hidden = true

vim.opt.backspace = {
  "indent",
  "eol",
  "nostop",
}

vim.opt.confirm = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.pumheight = 10

vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"

vim.opt.winblend = 20
vim.opt.pumblend = 20
vim.opt.termguicolors=true
vim.opt.background = "dark"

vim.opt.whichwrap = "b,s,h,l,~,<,>,[,]"

vim.opt.completeopt = { "menuone", "preview" }

vim.opt.scroll = 10
vim.opt.scrolloff = 3

vim.cmd.colorscheme "retrobox"
vim.cmd.highlight {"Normal", "guibg=none", "ctermbg=none"}
vim.cmd.highlight {"LineNr", "guibg=none", "ctermbg=none"}
