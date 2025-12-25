local git_props = {
    add = {
        icon = "+";
        hi = "StlGitAdd";
    };
    remove = {
        icon = "-";
        hi = "StlGitRemove";
    };
    change = {
        icon = "~";
        hi = "StlGitChange";
    };
    branch = {
        hi = "StlGitBranch";
    };
}

return function()
    local format = {}
    local status = vim.b.gitsigns_status_dict
    if status then
        table.insert(format, "%#" .. git_props.branch.hi .. "#(" .. status.head .. ")%*")
        if status.added and status.added > 0 then
            table.insert(format, "%#" .. git_props.add.hi .. "#" .. git_props.add.icon .. status.added .. "%*")
        end
        if status.removed and status.removed > 0 then
            table.insert(format, "%#" .. git_props.remove.hi .. "#" .. git_props.remove.icon .. status.removed .. "%*")
        end
        if status.changed and status.changed > 0 then
            table.insert(format, "%#" .. git_props.change.hi .. "#" .. git_props.change.icon .. status.changed .. "%*")
        end
    end
    return table.concat(format, "")
end

