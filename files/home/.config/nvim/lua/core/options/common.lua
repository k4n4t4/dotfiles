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
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.scrolloff = 3
vim.opt.sidescrolloff = 3

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = "split"
vim.opt.wildignorecase = true
vim.opt.wildmode = "list:full"
vim.opt.pumheight = 10

vim.opt.undofile = true
vim.opt.virtualedit = "block"


vim.opt.clipboard = ""
vim.api.nvim_create_autocmd("UIEnter", {
  once = true,
  callback = function()
    vim.opt.clipboard = "unnamedplus"
  end,
})

vim.env.EDITOR = "nvim --server \"$NVIM\" --remote-tab"

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
