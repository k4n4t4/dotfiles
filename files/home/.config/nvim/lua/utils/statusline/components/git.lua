local function git_info(bufnr)
    local b = (bufnr == 0 or bufnr == nil) and vim.api.nvim_get_current_buf() or bufnr
    if not vim.api.nvim_buf_is_valid(b or 0) then return nil end

    -- gitsigns.nvim
    local gs = vim.b[b].gitsigns_status_dict
    if gs then
        return {
            head = gs.head,
            added = gs.added,
            changed = gs.changed,
            removed = gs.removed,
        }
    end

    -- mini.git + mini.diff
    local git = vim.b[b].minigit_summary
    local diff = vim.b[b].minidiff_summary
    if git or diff then
        return {
            head = git and git.head_name or nil,
            added = diff and diff.add or 0,
            changed = diff and diff.change or 0,
            removed = diff and diff.delete or 0,
        }
    end

    return nil
end


return function(opts)
    local default_git_props = {
        add    = { icon = "+", hi = "GitSignsAdd" },
        remove = { icon = "-", hi = "GitSignsDelete" },
        change = { icon = "~", hi = "GitSignsChange" },
        branch = { hi = "Constant" },
    }
    local git_props = opts and vim.tbl_deep_extend("force", default_git_props, opts) or default_git_props

    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local status = git_info(bufnr)

    if not status then return end

    local components = {}
    table.insert(components, { hl = git_props.branch.hi, content = status.head or "" })

    if status.added and status.added > 0 then
        table.insert(components, { hl = git_props.add.hi, content = git_props.add.icon .. status.added })
    end
    if status.removed and status.removed > 0 then
        table.insert(components, { hl = git_props.remove.hi, content = git_props.remove.icon .. status.removed })
    end
    if status.changed and status.changed > 0 then
        table.insert(components, { hl = git_props.change.hi, content = git_props.change.icon .. status.changed })
    end

    return components
end
