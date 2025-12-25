local mode_props = {
    ["n"] = {
        name = "N";
        hi = "StlModeNormal";
    };
    ["no"] = {
        name = "NO";
        hi = "StlModeNormal";
    };
    ["nov"] = {
        name = "NOC";
        hi = "StlModeNormal";
    };
    ["noV"] = {
        name = "NOL";
        hi = "StlModeNormal";
    };
    ["no"] = {
        name = "NOB";
        hi = "StlModeNormal";
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
        hi = "StlModeTerminal";
    };
    ["ntT"] = {
        name = "NTT";
        hi = "StlModeTerminal";
    };

    ["v"] = {
        name = "V";
        hi = "StlModeVisual";
    };
    ["vs"] = {
        name = "VS";
        hi = "StlModeVisual";
    };
    ["V"] = {
        name = "VL";
        hi = "StlModeVisual";
    };
    ["Vs"] = {
        name = "VLS";
        hi = "StlModeVisual";
    };
    [""] = {
        name = "VB";
        hi = "StlModeVisual";
    };
    ["s"] = {
        name = "VBS";
        hi = "StlModeVisual";
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
        hi = "StlModeInsert";
    };
    ["ic"] = {
        name = "IC";
        hi = "StlModeInsert";
    };
    ["ix"] = {
        name = "IX";
        hi = "StlModeInsert";
    };

    ["R"] = {
        name = "R";
        hi = "StlModeReplace"
    };
    ["Rc"] = {
        name = "RC";
        hi = "StlModeReplace"
    };
    ["Rx"] = {
        name = "RX";
        hi = "StlModeReplace"
    };
    ["Rv"] = {
        name = "RV";
        hi = "StlModeReplace"
    };
    ["Rvc"] = {
        name = "RVC";
        hi = "StlModeReplace"
    };
    ["Rvx"] = {
        name = "RVX";
        hi = "StlModeReplace"
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
        hi = "StlModeConfirm";
    };
    ["!"] = {
        name = "SH";
        hi = "StlModeTerminal";
    };
    ["t"] = {
        name = "T";
        hi = "StlModeTerminal";
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
    local color = prop.hi or "StlModeOther"

    local format = {
        "%#" .. color .. "#",
        name,
        blocking and "=" or "",
        "%*",
    }

    return table.concat(format, "")
end
