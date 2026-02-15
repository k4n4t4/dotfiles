local M = {}

local hi = require "utils.highlight"

M.default_config = {
    highlight_groups = {
        "Normal",
        "NormalNC",
        "Folded",
        "FoldColumn",
        "NonText",
        "LineNr",
        "LineNrAbove",
        "LineNrBelow",
        "CursorLineNr",
        "SignColumn",
        "CursorLineSign",
        "EndOfBuffer",

        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",

        "NeoTreeNormal",
        "NeoTreeNormalNC",
        "NeoTreeEndOfBuffer",

        "NvimTreeNormal",
        "NvimTreeNormalNC",
        "NvimTreeEndOfBuffer",
    },
}

function M.transparent_background(highlight_groups)
    for _, name in ipairs(highlight_groups) do
        hi.set(name, {
            fg = "#A0A0A0",
            bg = "none",
        })
    end
end

function M.setup(config)
    M.transparent_background(config.highlight_groups or M.default_config.highlight_groups)
end

return M
