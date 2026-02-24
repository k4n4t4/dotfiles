local M = {}

M.group = vim.api.nvim_create_augroup("Utils_highlight", { clear = true })

M.registry = {}


--- Creates a deferred reference to a specific attribute of another highlight group.
--- Use with `M.set` to copy colors from existing groups at resolve time.
--- @param group_name string The highlight group to reference
--- @param attr string The attribute to reference (e.g. "fg", "bg")
--- @return { _ref: boolean, group: string, attr: string }
function M.ref(group_name, attr)
    return { _ref = true, group = group_name, attr = attr }
end

--- Returns true if any value in `opts` is a highlight reference created by `M.ref`.
--- @param opts table Highlight options table
--- @return boolean
function M.has_refs(opts)
    for _, v in pairs(opts) do
        if type(v) == "table" and v._ref then
            return true
        end
    end
    return false
end

--- Resolves all `M.ref` references in `opts` to their actual color values.
--- @param opts table Highlight options that may contain ref objects
--- @return table Resolved highlight options with plain values
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

--- Gets a highlight group's definition from the registry, resolving links/refs if needed.
--- Falls back to `M.force_get` for unregistered groups.
--- @param group_name string
--- @return table Highlight attributes
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

--- Sets a highlight group if it has not been registered yet (idempotent).
--- @param group_name string
--- @param opts table Highlight options (fg, bg, bold, italic, etc.)
function M.set(group_name, opts)
    if not M.registry[group_name] then
        M.registry[group_name] = opts
        vim.api.nvim_set_hl(0, group_name, M.resolve_opts(opts))
    end
end

--- Links a highlight group to another group (idempotent).
--- If `overrides` are provided, the group is set to the target's resolved attrs merged with overrides.
--- @param group_name string The group to define
--- @param target_group string The group to link to
--- @param overrides? table Attributes to override from the linked group
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

--- Builds a table of `M.ref` references for the listed attributes from a source group.
--- Useful for constructing highlight options that inherit specific colors.
--- @param source_group string Highlight group to copy from
--- @param attrs string[] Attribute names to reference (e.g. `{"fg", "bg"}`)
--- @return table Map of attr name -> ref object
function M.from(source_group, attrs)
    local result = {}
    for _, attr in ipairs(attrs) do
        result[attr] = M.ref(source_group, attr)
    end
    return result
end

--- Sets a highlight group using attributes copied from another group, with optional overrides.
--- @param group_name string The group to define
--- @param source_group string Source group to inherit attributes from
--- @param attrs string[] Attribute names to inherit
--- @param overrides? table Additional attributes to apply on top
function M.set_from(group_name, source_group, attrs, overrides)
    local opts = M.from(source_group, attrs)
    if overrides then
        opts = vim.tbl_extend("force", opts, overrides)
    end
    M.set(group_name, opts)
end

--- Gets a highlight group's definition directly from Neovim, bypassing the local registry.
--- @param group_name string
--- @return table Highlight attributes with links resolved
function M.force_get(group_name)
    return vim.api.nvim_get_hl(0, { name = group_name, link = false })
end

--- Overwrites a highlight group unconditionally, updating the registry and Neovim.
--- @param group_name string
--- @param opts table Highlight options
function M.force_set(group_name, opts)
    M.registry[group_name] = opts
    vim.api.nvim_set_hl(0, group_name, opts)
end

--- Re-applies all registered highlight groups. Called automatically on VimEnter and ColorScheme.
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

--- Returns a statusline/winbar highlight group string for use in format strings (e.g. `%#Name#`).
--- @param group_name string
--- @return string Highlight group escape sequence
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
