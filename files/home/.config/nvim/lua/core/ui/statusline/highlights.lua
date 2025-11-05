local statusline_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

-- Override highlights
local function status_line_highlights()
  local hls = {
    {"StatusLine", {
      fg = "#EEEEEE";
      bg = "none";
    }},
    {"StatusLineNC", {
      fg = "#AAAAAA";
      bg = "none";
    }},

    {"StatusLineModeNormal", {
      fg = "#99EE99";
      bg = "none";
    }},
    {"StatusLineModeInsert", {
      fg = "#EE9999";
      bg = "none";
    }},
    {"StatusLineModeReplace", {
      fg = "#EEEE99";
      bg = "none";
    }},
    {"StatusLineModeVisual", {
      fg = "#9999EE";
      bg = "none";
    }},
    {"StatusLineModeConfirm", {
      fg = "#999999";
      bg = "none";
    }},
    {"StatusLineModeTerminal", {
      fg = "#999999";
      bg = "none";
    }},
    {"StatusLineModeOther", {
      fg = "#EE99EE";
      bg = "none";
    }},

    {"StatusLineMacro", {
      fg = "#BB77EE";
      bg = "none";
    }},

    {"StatusLineFileFlag", {
      fg = "#DDEE99";
      bg = "none";
    }},

    {"StatusLineDiagnosticERROR", {
      fg = "#EE9999";
      bg = "none";
    }},
    {"StatusLineDiagnosticWARN", {
      fg = "#EEEE99";
      bg = "none";
    }},
    {"StatusLineDiagnosticINFO", {
      fg = "#99EEEE";
      bg = "none";
    }},
    {"StatusLineDiagnosticHINT", {
      fg = "#99EE99";
      bg = "none";
    }},

    {"StatusLineGitAdd", {
      fg = "#55CC55";
      bg = "none";
    }},
    {"StatusLineGitRemove", {
      fg = "#CC5555";
      bg = "none";
    }},
    {"StatusLineGitChange", {
      fg = "#5555CC";
      bg = "none";
    }},
    {"StatusLineGitBranch", {
      fg = "#CC9955";
      bg = "none";
    }},
  }
  for _, v in pairs(hls) do
    local name = v[1]
    local params = v[2]
    vim.api.nvim_set_hl(0, name, params)
  end
end
vim.api.nvim_create_autocmd({
  "VimEnter",
  "ColorScheme",
}, {
  group = statusline_group;
  callback = status_line_highlights;
})
