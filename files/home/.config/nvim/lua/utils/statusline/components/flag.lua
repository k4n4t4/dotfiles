local info = require("utils.info")

return function()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local format = {}
    table.insert(format, "%#StlFileFlag#")
    if vim.o.previewwindow then
        table.insert(format, "p")
    end
    if info.buf.is_readonly(bufnr) then
        table.insert(format, "r")
    elseif info.buf.is_modifiable(bufnr) then
        if info.buf.modified(bufnr) then
            table.insert(format, "+")
        end
    else
        table.insert(format, "-")
    end
    table.insert(format, "%*")
    return table.concat(format, "")
end
