local M = {}

local hi = require "utils.highlight"

--- Default highlight groups to make transparent.
--- @type string[]
M.default_groups = {
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
    "StatusLineTerm",
    "StatusLineTermNC",
    "TabLine",
    "TabLineSel",
    "TabLineFill",

    "NeoTreeNormal",
    "NeoTreeNormalNC",
    "NeoTreeEndOfBuffer",
    "NeoTreeIndentMarker",

    "NvimTreeNormal",
    "NvimTreeNormalNC",
    "NvimTreeEndOfBuffer",

    "RenderMarkdownTableFill",

    "TinyInlineDiagnosticVirtualTextArrow",

    "AvanteSideBarNormal",
    "AvanteSideBarWinSeparator",
    "AvanteSideBarWinHorizontalSeparator",
}

---@alias TransparentConfig
---| { groups: string[] }       # replace default groups entirely
---| { extend: string[] }       # append groups on top of defaults

--- Internal state
--- @type { enabled: boolean, groups: string[] }
M.state = { enabled = false, groups = {} }

--- Resolves the list of groups from config.
--- @param config? TransparentConfig
--- @return string[]
local function resolve_groups(config)
    config = config or {}
    if config.groups then
        return config.groups
    elseif config.extend then
        return vim.list_extend(vim.deepcopy(M.default_groups), config.extend)
    else
        return M.default_groups
    end
end

--- Applies transparent background to the given highlight groups,
--- preserving all other attributes (fg, bold, etc.).
--- @param groups string[]
local function apply(groups)
    for _, name in ipairs(groups) do
        hi.patch(name, { bg = "none" })
    end
end

--- Enables transparent background.
--- @param config? TransparentConfig
function M.enable(config)
    local groups = resolve_groups(config)
    M.state.enabled = true
    M.state.groups = groups
    apply(groups)
    hi.refresh()
end

--- Disables transparent background and restores the current colorscheme.
function M.disable()
    if not M.state.enabled then return end
    for _, name in ipairs(M.state.groups) do
        hi.registry[name] = nil
    end
    M.state.enabled = false
    M.state.groups = {}
    if vim.g.colors_name then
        pcall(vim.cmd.colorscheme, vim.g.colors_name)
    end
    hi.refresh()
end

--- Toggles transparent background on/off.
--- @param config? TransparentConfig  Used only when enabling.
function M.toggle(config)
    if M.state.enabled then
        M.disable()
    else
        M.enable(config)
    end
end

--- Sets up transparent background (alias for `enable`).
--- @param config? TransparentConfig
function M.setup(config)
    M.enable(config)
end

return M
