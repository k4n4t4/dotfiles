local M = {}

M.enabled = false
M.groups = {}
M.events = {}
M.default_groups = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "Folded",
    "FoldColumn",
    "NonText",
    "Terminal",
    "LineNr",
    "LineNrAbove",
    "LineNrBelow",
    "CursorLineNr",
    "SignColumn",
    "CursorLineSign",
    "EndOfBuffer",
}
M.default_events = {
    "VimEnter",
    "ColorScheme",
}

M.saved_hl = nil

function M.save_hl()
    M.saved_hl = {}
    for _, name in ipairs(M.groups) do
        M.saved_hl[name] = vim.api.nvim_get_hl(0, { name = name })
    end
end

function M.apply_transparent()
    for _, name in ipairs(M.groups) do
        local current = vim.api.nvim_get_hl(0, { name = name })
        vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", current, { bg = "none" }))
    end
end

function M.restore_hl()
    if not M.saved_hl then return end
    for name, hl_val in pairs(M.saved_hl) do
        vim.api.nvim_set_hl(0, name, hl_val)
    end
end

function M.enable()
    if M.enabled then return end
    M.enabled = true
    M.save_hl()
    M.apply_transparent()
end

function M.disable()
    if not M.enabled then return end
    M.enabled = false
    M.restore_hl()
    M.saved_hl = nil
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

    if opts.groups then
        M.groups = opts.groups
    elseif opts.extend then
        M.groups = vim.list_extend(vim.deepcopy(M.default_groups), opts.extend)
    else
        M.groups = vim.deepcopy(M.default_groups)
    end

    M.events = opts.events or vim.deepcopy(M.default_events)

    local augroup = vim.api.nvim_create_augroup("Transparent", { clear = true })
    vim.api.nvim_create_autocmd(M.events, {
        group = augroup,
        callback = function()
            if M.enabled then
                M.save_hl()
                M.apply_transparent()
            end
        end,
    })

    vim.api.nvim_create_user_command("TransparentEnable", M.enable, { desc = "Enable transparent background" })
    vim.api.nvim_create_user_command("TransparentDisable", M.disable, { desc = "Disable transparent background" })
    vim.api.nvim_create_user_command("TransparentToggle", M.toggle, { desc = "Toggle transparent background" })
end

return M
