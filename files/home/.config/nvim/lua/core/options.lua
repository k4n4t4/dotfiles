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

vim.opt.shortmess:append 'I'
vim.opt.belloff = "all"
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3
vim.opt.undofile = true

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

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


vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = function()
        vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"

        vim.opt.splitbelow = true
        vim.opt.splitright = true

        vim.opt.clipboard = "unnamedplus"
        vim.opt.virtualedit = "block"
        vim.opt.ignorecase = true
        vim.opt.smartcase = true
        vim.opt.inccommand = "split"
        vim.opt.wildignorecase = true
        vim.opt.wildmode = "list:full"
        vim.opt.pumheight = 10
        vim.opt.pumblend = 10


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

        local hl = require "utils.highlight"
        hl.set("DiagnosticUnnecessary", { link = "NONE", default = false })
    end,
})


local lsp = require "utils.lsp"

lsp.add_mason_bin_path()
lsp.auto_set("core.lsp-config")
