local M = {}

M.group = vim.api.nvim_create_augroup("Utils_highlight", { clear = true })

M.registry = {}

function M.force_get(group_name)
    return vim.api.nvim_get_hl(0, {
        name = group_name,
        link = false,
    })
end

function M.get(group_name)
    return M.registry[group_name] or M.force_get(group_name)
end

function M.set(group_name, opts)
    if not M.registry[group_name] then
        M.registry[group_name] = opts
        vim.api.nvim_set_hl(0, group_name, opts)
    end
end

function M.force_set(group_name, opts)
    M.registry[group_name] = opts
    vim.api.nvim_set_hl(0, group_name, opts)
end

function M.use(group_name)
    return "%#" .. group_name .. "#"
end

function M.refresh()
    for name, opts in pairs(M.registry) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = M.group,
    callback = function()
        M.refresh()
    end,
})

return M
