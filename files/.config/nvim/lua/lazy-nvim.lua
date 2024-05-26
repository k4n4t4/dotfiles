local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
  spec = {
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    { import = "plugins" },
  },
  default = {
    lazy = false,
    version = false,
  },
  install = {
    colorscheme = {
      "tokyonight"
    }
  },
  checker = {
    enabled = true
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "tutor",
      },
    },
  },
})
