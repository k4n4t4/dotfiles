local status = require("core.ui.statuscolumn.components")

function StatusColumn()
    if vim.wo.number then
        local line_number = status.number()
        local fold = status.fold()
        local separator = status.separator()
        return (
            "%s" ..
            "%=" ..
            line_number ..
            fold ..
            separator
        )
    else
        return ""
    end
end

function StatusColumnInactive()
    if vim.wo.number then
        local fold = status.fold()
        return (
            "%s" ..
            "%=" ..
            "%l" ..
            fold ..
            "│"
        )
    else
        return ""
    end
end
