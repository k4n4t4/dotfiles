function TransparentBackground()

  vim.cmd.highlight {"Normal",         "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NormalNC",       "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NonText",        "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"LineNr",         "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"CursorLineNr",   "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"SignColumn",     "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"CursorLineSign", "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"TabLine",        "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"TabLineFill",    "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"Folded",         "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"EndOfBuffer",    "guibg=none", "ctermbg=none"}

  vim.cmd.highlight {"NvimTreeNormal",      "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NvimTreeEndOfBuffer", "guibg=none", "ctermbg=none"}

end

vim.api.nvim_create_user_command( "TransparentBackground", TransparentBackground, { nargs = 0 } )

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = TransparentBackground
})

vim.cmd.colorscheme "habamax"
