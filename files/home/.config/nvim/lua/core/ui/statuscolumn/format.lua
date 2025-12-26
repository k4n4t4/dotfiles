local status = require("core.ui.statuscolumn.components")

function StatusColumn()
    local winid = vim.g.statusline_winid
    local curwin = vim.api.nvim_get_current_win()

    if winid == curwin then
        if vim.wo[winid].number then
            return (
                "%s" ..
                "%=" ..
                status.number() ..
                status.fold() ..
                status.separator()
            )
        else
            return ""
        end
    else
        if vim.wo[winid].number then
            return (
                "%s" ..
                "%=" ..
                "%l" ..
                status.fold() ..
                "│"
            )
        else
            return ""
        end
    end
end
