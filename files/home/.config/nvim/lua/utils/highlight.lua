local M = {}

M.group = vim.api.nvim_create_augroup("Utils_highlight", { clear = true })

M.registry = {}


function M.ref(group_name, attr)
    return { _ref = true, group = group_name, attr = attr }
end

function M.has_refs(opts)
    for _, v in pairs(opts) do
        if type(v) == "table" and v._ref then
            return true
        end
    end
    return false
end

function M.resolve_opts(opts)
    local resolved = {}
    for k, v in pairs(opts) do
        if type(v) == "table" and v._ref then
            resolved[k] = M.force_get(v.group)[v.attr]
        else
            resolved[k] = v
        end
    end
    return resolved
end

function M.get(group_name)
    local entry = M.registry[group_name]
    if entry then
        if entry._link or entry.link or M.has_refs(entry) then
            return M.force_get(group_name)
        end
        return entry
    end
    return M.force_get(group_name)
end

function M.set(group_name, opts)
    if not M.registry[group_name] then
        M.registry[group_name] = opts
        vim.api.nvim_set_hl(0, group_name, M.resolve_opts(opts))
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

function M.from(source_group, attrs)
    local result = {}
    for _, attr in ipairs(attrs) do
        result[attr] = M.ref(source_group, attr)
    end
    return result
end

function M.set_from(group_name, source_group, attrs, overrides)
    local opts = M.from(source_group, attrs)
    if overrides then
        opts = vim.tbl_extend("force", opts, overrides)
    end
    M.set(group_name, opts)
end

function M.force_get(group_name)
    return vim.api.nvim_get_hl(0, { name = group_name, link = false })
end

function M.force_set(group_name, opts)
    M.registry[group_name] = opts
    vim.api.nvim_set_hl(0, group_name, opts)
end

function M.refresh()
    for name, opts in pairs(M.registry) do
        if opts._link then
            local base = M.force_get(opts._link)
            vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", base, opts._overrides))
        elseif M.has_refs(opts) then
            vim.api.nvim_set_hl(0, name, M.resolve_opts(opts))
        else
            vim.api.nvim_set_hl(0, name, opts)
        end
    end
end

function M.use(group_name)
    return "%#" .. group_name .. "#"
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
    group = M.group,
    callback = function()
        M.refresh()
    end,
})

return M
