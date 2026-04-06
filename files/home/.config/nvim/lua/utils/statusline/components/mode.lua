local mapping    = require("utils.mapping")
local str        = require("utils.str")

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

-- Fixed display width to prevent statusline layout shifts when switching modes.
-- Covers all common labels (TERMINAL=8, V-REPLACE=9, N-TERMINAL=10).
local MODE_WIDTH = 10

return function()
    local mode  = vim.api.nvim_get_mode()
    local raw   = mode.mode
    local prop  = mapping.mode.get(raw)
    local hl    = mode_hi[raw] or mode_hi[raw:sub(1, 1)] or "StlModeOther"
    local label = str.center(prop.label, MODE_WIDTH)
    return "%#"..hl.."#" .. label .. (mode.blocking and "=" or "") .. "%*"
end
