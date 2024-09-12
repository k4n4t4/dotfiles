require "commands.transparent"
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = TransparentBackground
})

vim.cmd.colorscheme "onedark"
