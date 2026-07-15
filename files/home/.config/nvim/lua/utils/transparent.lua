local M = {}

local function patch_hl(name, val)
    local current = vim.api.nvim_get_hl(0, { name = name })
    local merged = vim.tbl_extend("force", current, val)
    vim.api.nvim_set_hl(0, name, merged)
end

M.enabled = false
M.groups = {}
M.events = {}
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
M.default_events = {
    "VimEnter",
    "ColorScheme",
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
    M.events = vim.deepcopy(M.default_events)
    if opts.groups then M.groups = opts.groups end
    if opts.events then M.events = opts.events end
    if opts.extend then
        M.groups = vim.list_extend(vim.deepcopy(M.default_groups), opts.extend)
    end

    vim.api.nvim_create_autocmd(M.events, {
        group = vim.api.nvim_create_augroup("Transparent", { clear = true }),
        callback = function()
            if M.enabled then
                M.enable()
            end
        end,
    })

    vim.api.nvim_create_user_command("TransparentEnable", M.enable, { desc = "Enable transparent background" })
    vim.api.nvim_create_user_command("TransparentDisable", M.disable, { desc = "Disable transparent background" })
    vim.api.nvim_create_user_command("TransparentToggle", M.toggle, { desc = "Toggle transparent background" })
end

return M
