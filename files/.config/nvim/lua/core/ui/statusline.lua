vim.opt.ruler = false
vim.opt.rulerformat = "%15(%l,%c%V%=%P%)"

vim.opt.laststatus = 3
vim.opt.statusline = "%{% v:lua.StatusLine(g:actual_curwin == win_getid()) %}"


local statusline_group = vim.api.nvim_create_augroup("StatusLine", { clear = true })

-- Redraw statusline when mode changed.
vim.api.nvim_create_autocmd("ModeChanged", {
  group = statusline_group,
  callback = function()
    vim.cmd.redrawstatus()
  end
})

-- Set highlights
local function status_line_highlights()
  local hls = {
    {"StatusLine", {
      fg = "#EEEEEE",
      bg = "none",
    }},
    {"StatusLine", {
      fg = "#EEEEEE",
      bg = "none",
    }},
    {"StatusLineNC", {
      fg = "#AAAAAA",
      bg = "none",
    }},

    {"StatusLineModeNormal", {
      fg = "#99EE99",
      bg = "none",
    }},
    {"StatusLineModeInsert", {
      fg = "#EE9999",
      bg = "none",
    }},
    {"StatusLineModeReplace", {
      fg = "#EEEE99",
      bg = "none",
    }},
    {"StatusLineModeVisual", {
      fg = "#9999EE",
      bg = "none",
    }},
    {"StatusLineModeConfirm", {
      fg = "#999999",
      bg = "none",
    }},
    {"StatusLineModeTerminal", {
      fg = "#999999",
      bg = "none",
    }},
    {"StatusLineModeOther", {
      fg = "#EE99EE",
      bg = "none",
    }},

    {"StatusLineMacro", {
      fg = "#BB77EE",
      bg = "none",
    }},

    {"StatusLineFileFlag", {
      fg = "#DDEE99",
      bg = "none",
    }},

    {"StatusLineDiagnosticERROR", {
      fg = "#EE9999",
      bg = "none",
    }},
    {"StatusLineDiagnosticWARN", {
      fg = "#EEEE99",
      bg = "none",
    }},
    {"StatusLineDiagnosticINFO", {
      fg = "#99EEEE",
      bg = "none",
    }},
    {"StatusLineDiagnosticHINT", {
      fg = "#99EE99",
      bg = "none",
    }},

    {"StatusLineGitAdd", {
      fg = "#55CC55",
      bg = "none",
    }},
    {"StatusLineGitRemove", {
      fg = "#CC5555",
      bg = "none",
    }},
    {"StatusLineGitChange", {
      fg = "#5555CC",
      bg = "none",
    }},
    {"StatusLineGitBranch", {
      fg = "#CC9955",
      bg = "none",
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
  callback = status_line_highlights
})

local mode_name = {
  ["n"]    = "N",
  ["no"]   = "NO",
  ["nov"]  = "NOC",
  ["noV"]  = "NOL",
  ["no^V"] = "NOB",

  ["niI"]  = "NI",
  ["niR"]  = "NR",
  ["niV"]  = "NV",
  ["nt"]   = "NT",
  ["ntT"]  = "NTT",

  ["v"]    = "V",
  ["vs"]   = "VS",
  ["V"]    = "VL",
  ["Vs"]   = "VLS",
  [""]    = "VB",
  ["s"]   = "VBS",

  ["s"]    = "S",
  ["S"]    = "SL",
  [""]    = "SB",

  ["i"]    = "I",
  ["ic"]   = "IC",
  ["ix"]   = "IX",

  ["R"]    = "R",
  ["Rc"]   = "RC",
  ["Rx"]   = "RX",
  ["Rv"]   = "RV",
  ["Rvc"]  = "RVC",
  ["Rvx"]  = "RVX",

  ["c"]    = "C",
  ["cr"]   = "CR",

  ["cv"]   = "EX",
  ["cvr"]  = "EXR",

  ["r"]    = "P",
  ["rm"]   = "M",
  ["r?"]   = "CF",
  ["!"]    = "SH",
  ["t"]    = "T",
}

local mode_color = {
  ["n"]    = "StatusLineModeNormal",
  ["no"]   = "StatusLineModeNormal",
  ["nov"]  = "StatusLineModeNormal",
  ["noV"]  = "StatusLineModeNormal",
  ["no^V"] = "StatusLineModeNormal",
  ["v"]    = "StatusLineModeVisual",
  ["vs"]   = "StatusLineModeVisual",
  ["V"]    = "StatusLineModeVisual",
  ["Vs"]   = "StatusLineModeVisual",
  [""]    = "StatusLineModeVisual",
  ["s"]   = "StatusLineModeVisual",
  ["i"]    = "StatusLineModeInsert",
  ["ic"]   = "StatusLineModeInsert",
  ["ix"]   = "StatusLineModeInsert",
  ["R"]    = "StatusLineModeReplace",
  ["Rc"]   = "StatusLineModeReplace",
  ["Rx"]   = "StatusLineModeReplace",
  ["Rv"]   = "StatusLineModeReplace",
  ["Rvc"]  = "StatusLineModeReplace",
  ["Rvx"]  = "StatusLineModeReplace",
  ["r?"]   = "StatusLineModeConfirm",
  ["!"]    = "StatusLineModeTerminal",
  ["t"]    = "StatusLineModeTerminal",
  ["nt"]   = "StatusLineModeNormal",
}

local function status_mode()
  local mode = vim.api.nvim_get_mode()
  local blocking = mode.blocking
  local name = mode_name[mode.mode] or "?"
  local color = mode_color[mode.mode] or "StatusLineModeOther"

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

local filetype_alias = {
  ["javascript"] = "js",
  ["typescript"] = "ts",
  ["python"]     = "py",
}


local function status_filetype(devicons)
  local ft = vim.bo.ft

  local icon, icon_hl, color
  if devicons then
    if devicons
    then
      icon, color = devicons.get_icon_color_by_filetype(ft)
      if icon then
        icon_hl = "StatusLineIcon@" .. ft

        vim.api.nvim_set_hl(0,icon_hl, {
          fg = color,
          bg = "none",
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

  return (not ft or ft == "") and "" or (filetype_alias[ft] or ft)
end

local git_icon = {
  add = "+",
  remove = "-",
  change = "~",
}

local git_color = {
  branch = "StatusLineGitBranch",
  add = "StatusLineGitAdd",
  remove = "StatusLineGitRemove",
  change = "StatusLineGitChange",
}

local function status_git()
  local format = {}
  local status = vim.b.gitsigns_status_dict
  if status then
    table.insert(format, "%#" .. git_color.branch .. "#(" .. status.head .. ")%*")
    if status.added and status.added > 0 then
      table.insert(format, "%#" .. git_color.add .. "#" .. git_icon.add .. status.added .. "%*")
    end
    if status.removed and status.removed > 0 then
      table.insert(format, "%#" .. git_color.remove .. "#" .. git_icon.remove .. status.removed .. "%*")
    end
    if status.changed and status.changed > 0 then
      table.insert(format, "%#" .. git_color.change .. "#" .. git_icon.change .. status.changed .. "%*")
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

local diagnostic_icon = {
  ERROR = "!",
  WARN = "*",
  INFO = "i",
  HINT = "?",
}

local diagnostic_color = {
  ERROR = "StatusLineDiagnosticERROR",
  WARN = "StatusLineDiagnosticWARN",
  INFO = "StatusLineDiagnosticINFO",
  HINT = "StatusLineDiagnosticHINT",
}

local utils_diagnostic = require "utils.diagnostic"
local function status_diagnostic()
  local format = {}
  local diagnoses = utils_diagnostic.get(0)
  for k, v in pairs(diagnoses) do
    if #v ~= 0 then
      local name = utils_diagnostic.SEVERITY[k]
      local icon = diagnostic_icon[name]
      local count = #v
      table.insert(format, "%#" .. diagnostic_color[name] .. "#" .. icon .. count .. "%*")
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
  return vim.fn.expand("%:t")
end

local function status_flag()
  local format = {}

  table.insert(format, "%#StatusLineFileFlag#")
  if vim.o.previewwindow then
    table.insert(format, "p")
  end
  if vim.bo.readonly then
    table.insert(format, "r")
  else
    if vim.bo.modifiable then
      if vim.bo.modified then
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
    _, devicons = pcall(require, "nvim-web-devicons")
  end,
})

function StatusLineActive()
  local macro = status_macro_recording()
  local mode = status_mode()
  local file = status_file()
  local flag = status_flag()
  local search = status_search_count()
  -- local lsp = status_lsp()
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
    -- lsp,
    encoding,
    filetype == "" and "" or " ",
    filetype,
    " ",
    fileformat,
    " ",
    "%l:%c",
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

function StatusLine(active)
  if vim.bo.ft == "neo-tree" then
    return StatusLineSimple()
  else
    if active == 1 then
      return StatusLineActive()
    else
      return StatusLineInactive()
    end
  end
end
