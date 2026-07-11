--[[ GENERAL SETTINGS ]]--

-- default shell
vim.opt.shell = "fish"

-- nvim server
vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"

-- mouse
vim.opt.mouse = "a"

-- clipboard
vim.opt.clipboard = "unnamedplus"

-- encoding
vim.opt.fileencoding = "utf-8"
vim.opt.fileencodings = {
    "utf-8",
    "utf-16",
    "iso-2022-jp",
    "euc-jp",
    "sjis",
    "cp932",
    "latin1",
    "ucs2le",
    "ucs-2",
    "default",
}

-- undo
vim.opt.undofile = true


--[[ EDITING SETTINGS ]]--

-- indentation
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- virtualedit
vim.opt.virtualedit = "block"

-- search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- split
vim.opt.splitbelow = true
vim.opt.splitright = true

-- wildmenu
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"

-- incremental command
vim.opt.inccommand = "split"


--[[ UI SETTINGS ]]--

-- transparent
require("utils.transparent").enable()

-- line number
vim.opt.number = true
vim.opt.relativenumber = false
require("utils.toggle_relnumber").enable()

-- shortmess
vim.opt.shortmess:append 'I'

-- bell
vim.opt.belloff = "all"

-- scrolloff
vim.opt.scrolloff = 5
vim.opt.sidescrolloff = 5

-- popup menu
vim.opt.pumheight = 10
vim.opt.pumblend = 10
vim.opt.winborder = "none"
vim.opt.pumborder = "none"

-- listchars
vim.opt.list = true
vim.opt.listchars = {
    tab      = ">-",
    extends  = ">",
    precedes = "<",
    trail    = "-",
    nbsp     = "+",
    conceal  = "@",
}

-- fillchars
vim.opt.fillchars = {
    eob = " ",
    fold = "·",
    foldopen = "v",
    foldsep = "¦",
    foldclose = ">",
    horiz = "━",
    horizup = "┻",
    horizdown = "┳",
    vert = "┃",
    vertleft = "┨",
    vertright = "┣",
    verthoriz = "╋",
    diff = "┃",
    msgsep = "‾",
}

-- diagnostic
vim.diagnostic.config {
    virtual_text = true,
    update_in_insert = false,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "!",
            [vim.diagnostic.severity.WARN] = "*",
            [vim.diagnostic.severity.INFO] = "i",
            [vim.diagnostic.severity.HINT] = "?",
        },
    },
}
local hi = require "utils.highlight"
hi.set("DiagnosticUnnecessary", { link = "NONE", default = false })


--[[ BUILTIN PLUGINS ]]--

-- disable builtin plugins
vim.opt.loadplugins = false

-- enable man plugin
vim.cmd.runtime("plugin/man.lua")
