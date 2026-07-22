---@diagnostic disable: undefined-global

vim.opt.loadplugins = false

vim.opt.number = false
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

vim.opt.laststatus = 0

vim.opt.showcmd = false
vim.opt.showmode = false

vim.opt.list = false

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

vim.opt.swapfile = false
vim.opt.undofile = false
vim.opt.backup   = false
vim.opt.writebackup = false

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

vim.opt.synmaxcol = 1000

vim.opt.termguicolors = true
vim.opt.background = "dark"

vim.cmd.highlight { "Normal",         "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "NormalNC",       "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "Folded",         "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "FoldColumn",     "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "NonText",        "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "LineNr",         "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "CursorLineNr",   "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "SignColumn",     "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "CursorLineSign", "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "TabLine",        "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "TabLineFill",    "guibg=none", "ctermbg=none" }
vim.cmd.highlight { "EndOfBuffer",    "guibg=none", "ctermbg=none" }

vim.keymap.set('n', "<ESC>", "<CMD>qa!<CR>")
vim.keymap.set('t', "<ESC>", "<C-\\><C-N>")


local input_line_number = tonumber(os.getenv("INPUT_LINE_NUMBER"))
local line = input_line_number + tonumber(os.getenv("CURSOR_LINE"))
local col = tonumber(os.getenv("CURSOR_COLUMN"))

local buf = vim.api.nvim_create_buf(true, true)
local term = vim.api.nvim_open_term(buf, {})

local scroll_back = vim.fn.system("cat /tmp/kitty_scrollback_buffer")
vim.api.nvim_chan_send(term, string.sub(scroll_back, 0, -2))

vim.schedule(function()
  vim.fn.cursor(line - 1, col)
end)
