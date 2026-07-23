--[[ GENERAL SETTINGS ]]--

-- exrc
vim.opt.exrc = true

-- default shell
vim.opt.shell = "fish"

-- nvim server
vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"

-- mouse
vim.opt.mouse = "a"

-- clipboard
vim.opt.clipboard:append("unnamedplus")

-- filename characters
vim.opt.isfname:append("@-@")

-- encoding
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

-- autocomplete
vim.opt.autocomplete = true


--[[ UI SETTINGS ]]--

-- line number
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.foldcolumn = "auto"
vim.opt.cursorline = true
vim.opt.cursorlineopt = "number"

-- help
vim.opt.helpheight = 15

--statusline
vim.opt.cmdheight = 0
vim.opt.laststatus = 3

-- tabline
vim.opt.showtabline = 2

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

-- winblend
vim.opt.winblend = 25

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
    foldsep = " ",
    foldinner = " ",
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
vim.api.nvim_set_hl(0, "DiagnosticUnnecessary", { link = "NONE", default = false })

-- filetype
vim.filetype.add {
    extension = {
        jsp = "jsp",
    },
}

-- treesitter
vim.treesitter.language.register("html", "jsp")
vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
    callback = function(_)
        local ok, _ = pcall(vim.treesitter.start)
        if ok then
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldtext = ""
            vim.opt.foldlevel = 99
            vim.opt.foldlevelstart = 99
        end
    end,
})

--[[ BUILTIN PLUGINS ]]--

-- disable builtin plugins
vim.opt.loadplugins = false

-- enable man plugin
vim.cmd.runtime("plugin/man.lua")
