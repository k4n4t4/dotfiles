local M = {}

local function patch_hl(name, val)
    local current = vim.api.nvim_get_hl(0, { name = name })
    local merged = vim.tbl_extend("force", current, val)
    vim.api.nvim_set_hl(0, name, merged)
end

M.groups = {}
M.enabled = false
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

function M.enable()
    M.enabled = true
    for _, name in ipairs(M.groups) do
        patch_hl(name, { bg = "none" })
    end
end

function M.disable()
    M.enabled = false
    if vim.g.colors_name then
        pcall(vim.cmd.colorscheme, vim.g.colors_name)
    end
end

function M.toggle()
    if M.enabled then
        M.disable()
    else
        M.enable()
    end
end

function M.setup(opts)
    opts = opts or {}
    M.groups = vim.deepcopy(M.default_groups)
    if opts.groups then
        M.groups = opts.groups
    end
    if opts.extend then
        M.groups = vim.list_extend(vim.deepcopy(M.default_groups), opts.extend)
    end
end

return M
