local M = {}

M.default_config = {
  events = {
    'VimEnter',
    'ColorScheme',
  };
  highlight_groups = {
    "Normal",
    "NormalNC",
    "Folded",
    "FoldColumn",
    "NonText",
    "CursorLineNr",
    "SignColumn",
    "CursorLineSign",
    "TabLine",
    "TabLineFill",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC",

    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",

    "NvimTreeNormal",
    "NvimTreeNormalNC",
    "NvimTreeEndOfBuffer",
  };
}

function M.transparent_background(highlight_groups)
  for _, name in ipairs(highlight_groups) do
    vim.api.nvim_set_hl(0, name, { bg = "none" })
  end
end

function M.setup(config)
  vim.api.nvim_create_autocmd(config.events or M.default_config.events, {
    callback = function()
      M.transparent_background(config.highlight_groups or M.default_config.highlight_groups)
    end;
  })
end

return M
