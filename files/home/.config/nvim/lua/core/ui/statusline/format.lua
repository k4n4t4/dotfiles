local mode_props = {
  ["n"] = {
    name = "N";
    hi = "StatusLineModeNormal";
  };
  ["no"] = {
    name = "NO";
    hi = "StatusLineModeNormal";
  };
  ["nov"] = {
    name = "NOC";
    hi = "StatusLineModeNormal";
  };
  ["noV"] = {
    name = "NOL";
    hi = "StatusLineModeNormal";
  };
  ["no"] = {
    name = "NOB";
    hi = "StatusLineModeNormal";
  };

  ["niI"] = {
    name = "NI";
  };
  ["niR"] = {
    name = "NR";
  };
  ["niV"] = {
    name = "NV";
  };
  ["nt"] = {
    name = "NT";
    hi = "StatusLineModeTerminal";
  };
  ["ntT"] = {
    name = "NTT";
    hi = "StatusLineModeTerminal";
  };

  ["v"] = {
    name = "V";
    hi = "StatusLineModeVisual";
  };
  ["vs"] = {
    name = "VS";
    hi = "StatusLineModeVisual";
  };
  ["V"] = {
    name = "VL";
    hi = "StatusLineModeVisual";
  };
  ["Vs"] = {
    name = "VLS";
    hi = "StatusLineModeVisual";
  };
  [""] = {
    name = "VB";
    hi = "StatusLineModeVisual";
  };
  ["s"] = {
    name = "VBS";
    hi = "StatusLineModeVisual";
  };

  ["s"] = {
    name = "S";
  };
  ["S"] = {
    name = "SL";
  };
  [""] = {
    name = "SB";
  };

  ["i"] = {
    name = "I";
    hi = "StatusLineModeInsert";
  };
  ["ic"] = {
    name = "IC";
    hi = "StatusLineModeInsert";
  };
  ["ix"] = {
    name = "IX";
    hi = "StatusLineModeInsert";
  };

  ["R"] = {
    name = "R";
    hi = "StatusLineModeReplace"
  };
  ["Rc"] = {
    name = "RC";
    hi = "StatusLineModeReplace"
  };
  ["Rx"] = {
    name = "RX";
    hi = "StatusLineModeReplace"
  };
  ["Rv"] = {
    name = "RV";
    hi = "StatusLineModeReplace"
  };
  ["Rvc"] = {
    name = "RVC";
    hi = "StatusLineModeReplace"
  };
  ["Rvx"] = {
    name = "RVX";
    hi = "StatusLineModeReplace"
  };

  ["c"] = {
    name = "C";
  };
  ["cr"] = {
    name = "CR";
  };

  ["cv"] = {
    name = "EX";
  };
  ["cvr"] = {
    name = "EXR";
  };

  ["r"] = {
    name = "P";
  };
  ["rm"] = {
    name = "M";
  };
  ["r?"] = {
    name = "CF";
    hi = "StatusLineModeConfirm";
  };
  ["!"] = {
    name = "SH";
    hi = "StatusLineModeTerminal";
  };
  ["t"] = {
    name = "T";
    hi = "StatusLineModeTerminal";
  };
}
local function status_mode()
  local mode = vim.api.nvim_get_mode()
  local blocking = mode.blocking

  local prop = mode_props[mode.mode] or {
    name = nil;
    hi = nil;
  }

  local name = prop.name or "?"
  local color = prop.hi or "StatusLineModeOther"

  local format = {
    "%#" .. color .. "#",
    name,
    blocking and "=" or "",
    "%*",
  }

  return table.concat(format, "")
end

local function status_encoding()
  return vim.o.fenc or vim.o.enc
end

local function status_fileformat()
  return vim.o.ff
end

local filetype_aliases = {
  ["javascript"] = "js";
  ["typescript"] = "ts";
  ["python"]     = "py";
}
local function status_filetype(devicons)
  local ft = vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].filetype

  local icon, icon_hl, color
  if devicons then
    if devicons
    then
      icon, color = devicons.get_icon_color_by_filetype(ft)
      if icon then
        icon_hl = "StatusLineIcon@" .. ft

        vim.api.nvim_set_hl(0,icon_hl, {
          fg = color;
          bg = "none";
        })

        icon_hl = "%#" .. icon_hl .. "#"

        local format = {
          icon_hl,
          icon,
          "%*",
        }

        return table.concat(format, "")
      end
    end
  end

  return (not ft or ft == "") and "" or (filetype_aliases[ft] or ft)
end

local git_props = {
  add = {
    icon = "+";
    hi = "StatusLineGitAdd";
  };
  remove = {
    icon = "-";
    hi = "StatusLineGitRemove";
  };
  change = {
    icon = "~";
    hi = "StatusLineGitChange";
  };
  branch = {
    hi = "StatusLineGitBranch";
  };
}
local function status_git()
  local format = {}
  local status = vim.b.gitsigns_status_dict
  if status then
    table.insert(format, "%#" .. git_props.branch.hi .. "#(" .. status.head .. ")%*")
    if status.added and status.added > 0 then
      table.insert(format, "%#" .. git_props.add.hi .. "#" .. git_props.add.icon .. status.added .. "%*")
    end
    if status.removed and status.removed > 0 then
      table.insert(format, "%#" .. git_props.remove.hi .. "#" .. git_props.remove.icon .. status.removed .. "%*")
    end
    if status.changed and status.changed > 0 then
      table.insert(format, "%#" .. git_props.change.hi .. "#" .. git_props.change.icon .. status.changed .. "%*")
    end
  end
  return table.concat(format, "")
end

local utils_lsp = require "utils.lsp"
local function status_lsp()
  local clients, others = utils_lsp.get(0)
  if others["null-ls"] and #others["null-ls"] > 0 then
    table.insert(clients, "null-ls:[" .. table.concat(others["null-ls"], ", ") .. "]")
  end
  return table.concat(clients, ", ")
end

local diagnostic_props = {
  ERROR = {
    icon = "!";
    hi = "StatusLineDiagnosticERROR";
  };
  WARN = {
    icon = "*";
    hi = "StatusLineDiagnosticWARN";
  };
  INFO = {
    icon = "i";
    hi = "StatusLineDiagnosticINFO";
  };
  HINT = {
    icon = "?";
    hi = "StatusLineDiagnosticHINT";
  };
}

local function get_diagnoses(bufnr, severity_list)
  severity_list = severity_list or {
    vim.diagnostic.severity.ERROR,
    vim.diagnostic.severity.WARN,
    vim.diagnostic.severity.INFO,
    vim.diagnostic.severity.HINT,
  }
  local diagnoses = {}
  for _, severity in pairs(severity_list) do
    diagnoses[severity] = vim.diagnostic.get(
      bufnr,
      {
        severity = severity
      }
    )
  end
  return diagnoses
end

local function status_diagnostic()
  local format = {}
  local diagnoses = get_diagnoses(0)
  for k, v in pairs(diagnoses) do
    if #v ~= 0 then
      local name = vim.diagnostic.severity[k]
      local count = #v
      table.insert(format,
        "%#" .. diagnostic_props[name].hi .. "#" ..
        diagnostic_props[name].icon ..
        count ..
        "%*"
      )
    end
  end
  return table.concat(format, "")
end

local function status_macro_recording()
  local format = {}
  local macro = vim.fn.reg_recording()
  if macro ~= "" then
    table.insert(format, "%#StatusLineMacro#")
    table.insert(format, "@" .. macro)
    table.insert(format, "%*")
  end
  return table.concat(format, "")
end

local function status_search_count()
  local format = {}

  local search = vim.fn.searchcount()

  if search.total ~= nil and vim.v.hlsearch == 1 then
    table.insert(format, "[" .. search.current .. "/" .. search.total .. "] ")
  end

  return table.concat(format, "")
end

local function status_file()
  local full_path = vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
  return vim.fn.fnamemodify(full_path, ":t")
end

local function status_flag()
  local format = {}

  table.insert(format, "%#StatusLineFileFlag#")
  if vim.o.previewwindow then
    table.insert(format, "p")
  end
  if vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].readonly then
    table.insert(format, "r")
  else
    if vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].modifiable then
      if vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].modified then
        table.insert(format, "+")
      end
    else
        table.insert(format, "-")
    end
  end
  table.insert(format, "%*")

  return table.concat(format, "")
end


local devicons
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    local result, ret = pcall(require, "nvim-web-devicons")
    if result then
      devicons = ret
    end
  end
})

function StatusLineActive()
  local macro = status_macro_recording()
  local mode = status_mode()
  local file = status_file()
  local flag = status_flag()
  local search = status_search_count()
  local lsp = status_lsp()
  local diagnostic = status_diagnostic()
  local git = status_git()
  local encoding = status_encoding()
  local fileformat = status_fileformat()

  local filetype = status_filetype(devicons)

  local status_line = {
    mode,
    " ",
    macro ~= "" and macro .. " " or "",
    file,
    flag,
    " ",
    git,
    " ",
    diagnostic,
    "%=%<",
    "%S",
    " ",
    search,
    lsp,
    " ",
    encoding,
    filetype == "" and "" or " ",
    filetype,
    " ",
    fileformat,
    " ",
    "%l:%c",
    " ",
    "%P",
  }
  return table.concat(status_line, "")
end

function StatusLineInactive()
  local mode = status_mode()
  local file = status_file()
  local flag = status_flag()
  local encoding = status_encoding()
  local fileformat = status_fileformat()
  local filetype = status_filetype()
  local status_line = {
    mode,
    " ",
    file,
    flag,
    "%=%<",
    "%S",
    encoding,
    filetype == "" and "" or " ",
    filetype,
    " ",
    fileformat,
    " ",
    "%l:%c",
    " ",
    "%P",
  }
  return table.concat(status_line, "")
end

function StatusLineSimple()
  local mode = status_mode()
  local filetype = status_filetype()
  local status_line = {
    mode,
    "%=%<",
    filetype .. " ",
  }
  return table.concat(status_line, "")
end

-- TODO: buf...
function StatusLine()
  local current_winid = vim.api.nvim_get_current_win()
  local statusline_winid = vim.g.statusline_winid
  local active = current_winid == statusline_winid
  local statusline_bufnr = vim.api.nvim_win_get_buf(statusline_winid)

  if vim.bo[statusline_bufnr].filetype == "neo-tree" then
    return StatusLineSimple()
  else
    if active then
      return StatusLineActive()
    else
      return StatusLineInactive()
    end
  end
end
