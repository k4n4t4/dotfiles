require "commands.transparent"
vim.api.nvim_create_autocmd("VimEnter", {
  callback = TransparentBackground
})

vim.cmd.colorscheme "tokyonight-moon"
