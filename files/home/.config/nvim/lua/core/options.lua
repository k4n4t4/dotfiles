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

vim.opt.ambiwidth = "single"


vim.opt.debug = 'throw'


vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.opt.cmdwinheight = 10

vim.opt.winblend = 20
vim.opt.pumblend = 20

vim.opt.pumheight = 10
vim.opt.pumwidth = 10

vim.opt.wrap = true
vim.opt.display = "lastline"
vim.opt.breakat = " ^I!@*-+;:,./?"
vim.opt.linebreak = false
vim.opt.breakindent = false
vim.opt.showbreak = ""

vim.opt.wildmenu = true
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"

vim.opt.scroll = 10
vim.opt.scrolloff = 3
vim.opt.sidescroll = 1
vim.opt.sidescrolloff = 3

vim.opt.spell = false
vim.opt.spelllang = { "en", "ja" }

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


vim.opt.directory = vim.fn.stdpath("state") .. "/swap//"
vim.opt.undodir = vim.fn.stdpath("state") .. "/undo//"
vim.opt.backupdir = vim.fn.stdpath("state") .. "/backup//"

vim.opt.swapfile = true
vim.opt.undofile = true
vim.opt.backup = true
vim.opt.writebackup = true
vim.opt.backupext = ".bak"


vim.opt.title = true
vim.opt.mouse = "a"
vim.opt.clipboard:append "unnamedplus"

vim.opt.autoread = true

vim.opt.hidden = true

vim.opt.confirm = true

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.virtualedit = "block"

vim.opt.gdefault = false

vim.opt.whichwrap = "b,s,~,<,>,[,]"

vim.opt.backspace = { "indent", "eol", "nostop" }

vim.opt.nrformats = { "bin", "octal", "hex" }

vim.opt.showmatch = true
vim.opt.matchtime = 1
vim.opt.matchpairs = { "(:)", "{:}", "[:]", "<:>" }

vim.opt.completeopt = { "menuone", "preview" }

vim.opt.viewoptions = { "folds", "cursor", "curdir" }

vim.opt.synmaxcol = 1000


vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"


-- nil: enable
--   1: disable

vim.g.skip_defaults_vim         = 1
vim.g.skip_loading_mswin        = 1

vim.g.did_install_default_menus = 1
vim.g.did_install_syntax_menu   = 1
vim.g.did_indent_on             = 1
vim.g.did_load_filetypes        = nil
vim.g.did_load_ftplugin         = nil

vim.g.loaded_2html_plugin       = 1
vim.g.loaded_gzip               = 1
vim.g.loaded_tar                = 1
vim.g.loaded_tarPlugin          = 1
vim.g.loaded_zip                = 1
vim.g.loaded_zipPlugin          = 1
vim.g.loaded_vimball            = 1
vim.g.loaded_vimballPlugin      = 1
vim.g.loaded_netrw              = 1
vim.g.loaded_netrwPlugin        = 1
vim.g.loaded_netrwSettings      = 1
vim.g.loaded_netrwFileHandlers  = 1
vim.g.loaded_getscript          = 1
vim.g.loaded_getscriptPlugin    = 1
vim.g.loaded_man                = 1
vim.g.loaded_matchit            = 1
vim.g.loaded_matchparen         = 1
vim.g.loaded_remote_plugins     = 1
vim.g.loaded_shada_plugin       = 1
vim.g.loaded_spellfile_plugin   = 1
vim.g.loaded_tutor_mode_plugin  = 1
vim.g.loaded_rrhelper           = 1

if not vim.g.loaded_netrw then
  vim.g.netrw_liststyle = 3
  vim.g.netrw_banner = 0
  vim.g.netrw_sizestyle = "H"
  vim.g.netrw_timefmt = "%m-%d-%Y %a %H:%M:%S"
  vim.g.netrw_preview = 1
  vim.g.netrw_winsize = 30
  vim.g.netrw_browse_split = 3
end
