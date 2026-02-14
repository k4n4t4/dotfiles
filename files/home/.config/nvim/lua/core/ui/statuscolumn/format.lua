local status = require("core.ui.statuscolumn.components")

function StatusColumn()
    local winid = vim.g.statusline_winid
    local curwin = vim.api.nvim_get_current_win()
    local is_active = winid == curwin

    if is_active then
        return (
            "%s" ..
            "%=" ..
            (vim.wo[winid].number and status.number() or "") ..
            status.fold() ..
            (vim.wo[winid].number and status.separator() or "")
        )
    else
        return (
            "%s" ..
            "%=" ..
            (vim.wo[winid].number and "%l" or "") ..
            status.fold() ..
            (vim.wo[winid].number and "│" or "")
        )
    end
end
