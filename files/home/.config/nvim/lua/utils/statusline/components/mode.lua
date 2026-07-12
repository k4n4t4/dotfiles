-- Maps the first character of the raw mode string to a highlight group.
local mode_hi    = {
    ["n"] = "StlModeNormal",
    ["i"] = "StlModeInsert",
    ["R"] = "StlModeReplace",
    ["v"] = "StlModeVisual",
    ["V"] = "StlModeVisual",
    [""] = "StlModeVisual",
    ["t"] = "StlModeTerminal",
    ["!"] = "StlModeTerminal",
    ["r?"] = "StlModeConfirm",
}

local mode_label = {
    ["n"]   = { name = "N", label = "NORMAL" },
    ["no"]  = { name = "NO", label = "O-PENDING" },
    ["nov"] = { name = "NOC", label = "O-PENDING-C" },
    ["noV"] = { name = "NOL", label = "O-PENDING-L" },
    ["no"] = { name = "NOB", label = "O-PENDING-B" },
    ["niI"] = { name = "NI", label = "N-INSERT" },
    ["niR"] = { name = "NR", label = "N-REPLACE" },
    ["niV"] = { name = "NV", label = "N-VISUAL" },
    ["nt"]  = { name = "NT", label = "N-TERMINAL" },
    ["ntT"] = { name = "NTT", label = "N-TERM-T" },
    ["v"]   = { name = "V", label = "VISUAL" },
    ["vs"]  = { name = "VS", label = "VISUAL-S" },
    ["V"]   = { name = "VL", label = "V-LINE" },
    ["Vs"]  = { name = "VLS", label = "V-LINE-S" },
    [""]   = { name = "VB", label = "V-BLOCK" },
    ["s"]  = { name = "VBS", label = "V-BLOCK-S" },
    ["s"]   = { name = "S", label = "SELECT" },
    ["S"]   = { name = "SL", label = "S-LINE" },
    [""]   = { name = "SB", label = "S-BLOCK" },
    ["i"]   = { name = "I", label = "INSERT" },
    ["ic"]  = { name = "IC", label = "INSERT-C" },
    ["ix"]  = { name = "IX", label = "INSERT-X" },
    ["R"]   = { name = "R", label = "REPLACE" },
    ["Rc"]  = { name = "RC", label = "REPLACE-C" },
    ["Rx"]  = { name = "RX", label = "REPLACE-X" },
    ["Rv"]  = { name = "RV", label = "V-REPLACE" },
    ["Rvc"] = { name = "RVC", label = "V-REPLACE-C" },
    ["Rvx"] = { name = "RVX", label = "V-REPLACE-X" },
    ["c"]   = { name = "C", label = "COMMAND" },
    ["cr"]  = { name = "CR", label = "COMMAND-R" },
    ["cv"]  = { name = "EX", label = "EX" },
    ["cvr"] = { name = "EXR", label = "EX-R" },
    ["r"]   = { name = "P", label = "ENTER" },
    ["rm"]  = { name = "M", label = "MORE" },
    ["r?"]  = { name = "CF", label = "CONFIRM" },
    ["!"]   = { name = "SH", label = "SHELL" },
    ["t"]   = { name = "T", label = "TERMINAL" },
}

-- Fixed display width to prevent statusline layout shifts when switching modes.
-- Covers all common labels (TERMINAL=8, V-REPLACE=9, N-TERMINAL=10).
local MODE_WIDTH = 10

return function()
    local mode  = vim.api.nvim_get_mode()
    local mode_raw   = mode.mode
    local mode_blocking   = mode.blocking
    local prop  = mode_label[mode_raw]
    local hl    = mode_hi[mode_raw] or mode_hi[mode_raw:sub(1, 1)] or "StlModeOther"
    local label = require("utils.str").center(prop.label, MODE_WIDTH)
    return "%#"..hl.."#" .. label .. (mode_blocking and "=" or "") .. "%*"
end
