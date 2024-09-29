local M = {}

function M.TransparentBackground()
  vim.cmd.highlight {"Normal",         "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NormalNC",       "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"Folded",         "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"FoldColumn",     "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NonText",        "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"LineNr",         "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"CursorLineNr",   "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"SignColumn",     "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"CursorLineSign", "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"TabLine",        "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"TabLineFill",    "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"EndOfBuffer",    "guibg=none", "ctermbg=none"}

  vim.cmd.highlight {"NeoTreeNormal",      "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NeoTreeNormalNC",    "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NeoTreeEndOfBuffer", "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NvimTreeNormal",      "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NvimTreeNormalNC",    "guibg=none", "ctermbg=none"}
  vim.cmd.highlight {"NvimTreeEndOfBuffer", "guibg=none", "ctermbg=none"}
end

function M.setup(config)
  vim.api.nvim_create_user_command( "TransparentBackground", M.TransparentBackground, { nargs = 0 } )
  if config.events then
    vim.api.nvim_create_autocmd(config.events, {
      callback = M.TransparentBackground
    })
  end
end

return M
