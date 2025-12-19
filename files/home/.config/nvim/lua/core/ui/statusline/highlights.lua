local statusline_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

local function status_line_highlights()
  local hls = {
    StatusLine = {
      fg = "#EEEEEE";
      bg = "none";
    };
    StatusLineNC = {
      fg = "#AAAAAA";
      bg = "none";
    };

    StlNormal = {
      fg = "#EEEEEE";
      bg = "none";
    };
    StlNC = {
      fg = "#AAAAAA";
      bg = "none";
    };

    StlModeNormal = {
      fg = "#99EE99";
      bg = "none";
    };
    StlModeInsert = {
      fg = "#EE9999";
      bg = "none";
    };
    StlModeReplace = {
      fg = "#EEEE99";
      bg = "none";
    };
    StlModeVisual = {
      fg = "#9999EE";
      bg = "none";
    };
    StlModeConfirm = {
      fg = "#999999";
      bg = "none";
    };
    StlModeTerminal = {
      fg = "#999999";
      bg = "none";
    };
    StlModeOther = {
      fg = "#EE99EE";
      bg = "none";
    };

    StlMacro = {
      fg = "#BB77EE";
      bg = "none";
    };

    StlFileFlag = {
      fg = "#DDEE99";
      bg = "none";
    };

    StlDiagnosticERROR = {
      fg = "#EE9999";
      bg = "none";
    };
    StlDiagnosticWARN = {
      fg = "#EEEE99";
      bg = "none";
    };
    StlDiagnosticINFO = {
      fg = "#99EEEE";
      bg = "none";
    };
    StlDiagnosticHINT = {
      fg = "#99EE99";
      bg = "none";
    };

    StlGitAdd = {
      fg = "#55CC55";
      bg = "none";
    };
    StlGitRemove = {
      fg = "#CC5555";
      bg = "none";
    };
    StlGitChange = {
      fg = "#5555CC";
      bg = "none";
    };
    StlGitBranch = {
      fg = "#CC9955";
      bg = "none";
    };
  }
  for name, spec in pairs(hls) do
    vim.api.nvim_set_hl(0, name, spec)
  end
end

vim.api.nvim_create_autocmd({
  "VimEnter",
  "ColorScheme",
}, {
  group = statusline_group;
  callback = status_line_highlights;
})

-- Redraw statusline when mode changed. (e.g. 'ix' mode)
vim.api.nvim_create_autocmd("ModeChanged", {
  group = statusline_group;
  callback = function()
    vim.cmd.redrawstatus()
  end;
})
