return function(opts)
    local default_git_props = {
        add    = { icon = "+", hi = "StlGitAdd" },
        remove = { icon = "-", hi = "StlGitRemove" },
        change = { icon = "~", hi = "StlGitChange" },
        branch = { hi = "StlGitBranch" },
    }
    local git_props = opts and vim.tbl_deep_extend("force", default_git_props, opts) or default_git_props

    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local status = require("utils.info").buf.git(bufnr)

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
