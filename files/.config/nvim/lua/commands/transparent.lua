local M = {}


local function bgnone(name)
  vim.cmd.highlight {name, "guibg=none", "ctermbg=none"}
end

function M.TransparentBackground()
  bgnone("Normal")
  bgnone("NormalNC")
  bgnone("Folded")
  bgnone("FoldColumn")
  bgnone("NonText")
  bgnone("LineNr")
  bgnone("CursorLineNr")
  bgnone("SignColumn")
  bgnone("CursorLineSign")
  bgnone("TabLine")
  bgnone("TabLineFill")
  bgnone("EndOfBuffer")

  bgnone("NeoTreeNormal")
  bgnone("NeoTreeNormalNC")
  bgnone("NeoTreeEndOfBuffer")
  bgnone("NvimTreeNormal")
  bgnone("NvimTreeNormalNC")
  bgnone("NvimTreeEndOfBuffer")
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
