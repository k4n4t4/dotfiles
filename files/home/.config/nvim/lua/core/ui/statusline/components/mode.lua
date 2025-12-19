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

return function()
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
