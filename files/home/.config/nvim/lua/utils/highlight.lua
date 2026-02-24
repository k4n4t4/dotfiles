local M = {}

M.group = vim.api.nvim_create_augroup("Utils_highlight", { clear = true })

M.registry = {}

function M.get(group_name)
    local entry = M.registry[group_name]
    if entry then
        if entry._link or entry.link then
            return M.force_get(group_name)
        end
        return entry
    end
    return M.force_get(group_name)
end

function M.set(group_name, opts)
    if not M.registry[group_name] then
        M.registry[group_name] = opts
        vim.api.nvim_set_hl(0, group_name, opts)
    end
end

function M.link(group_name, target_group, overrides)
    if not M.registry[group_name] then
        if overrides then
            M.registry[group_name] = { _link = target_group, _overrides = overrides }
            local base = vim.api.nvim_get_hl(0, { name = target_group, link = false })
            vim.api.nvim_set_hl(0, group_name, vim.tbl_extend("force", base, overrides))
        else
            M.registry[group_name] = { link = target_group }
            vim.api.nvim_set_hl(0, group_name, { link = target_group })
        end
    end
end

function M.force_get(group_name)
    return vim.api.nvim_get_hl(0, { name = group_name, link = false })
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
        if opts._link then
            local base = M.force_get(opts._link)
            vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", base, opts._overrides))
        else
            vim.api.nvim_set_hl(0, name, opts)
        end
    end
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = M.group,
    callback = function()
        M.refresh()
    end,
})

return M
