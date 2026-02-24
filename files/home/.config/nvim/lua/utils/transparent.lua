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
        "NeoTreeIndentMarker",

        "NvimTreeNormal",
        "NvimTreeNormalNC",
        "NvimTreeEndOfBuffer",

        "RenderMarkdownTableFill",
    },
}

--- Sets the specified highlight groups to use a transparent background.
--- @param highlight_groups string[] List of highlight group names to make transparent
function M.transparent_background(highlight_groups)
    for _, name in ipairs(highlight_groups) do
        hi.set(name, {
            fg = "#A0A0A0",
            bg = "none",
        })
    end
end

--- Sets up transparent background using the provided config or module defaults.
--- @param config { highlight_groups?: string[] }
function M.setup(config)
    M.transparent_background(config.highlight_groups or M.default_config.highlight_groups)
end

return M
