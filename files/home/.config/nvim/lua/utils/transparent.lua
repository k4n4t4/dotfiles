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

--- Sets the specified highlight groups to use a transparent background,
--- preserving all other attributes (fg, bold, etc.).
--- @param highlight_groups string[] List of highlight group names to make transparent
function M.transparent_background(highlight_groups)
    for _, name in ipairs(highlight_groups) do
        hi.patch(name, {
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
