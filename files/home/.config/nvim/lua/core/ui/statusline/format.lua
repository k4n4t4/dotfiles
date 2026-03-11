return function()
    local status = require("core.ui.statusline.components")
    local hi = require("utils.highlight")

    local sep = hi.use("StlSep") .. "│" .. "%*"

    local current_winid = vim.api.nvim_get_current_win()
    local statusline_winid = vim.g.statusline_winid
    local active = current_winid == statusline_winid
    local statusline_bufnr = vim.api.nvim_win_get_buf(statusline_winid)

    local status_line

    local special_filetypes = {
        ["neo-tree"] = true,
        ["NvimTree"] = true,
    }
    if special_filetypes[vim.bo[statusline_bufnr].filetype] then
        status_line = {
            "%=",
            status.filetype(),
        }
    else
        if active then
            status_line = {
                status.mode(),
                " ", sep, " ",
                status.macro_recording(),
                " ",
                status.file(),
                status.flag(),
                " ",
                status.git(),
                " ",
                status.diagnostic(),
                "%=%<",
                "%S ",
                status.search_count(),
                status.lsp(),
                " ",
                status.filetype(),
                " ", sep, " ",
                status.encoding(), " ", status.fileformat(),
                " ", sep, " ",
                "%l:%c|%P",
            }
        else
            status_line = {
                status.mode(),
                " ",
                status.file(),
                status.flag(),
                "%=%<",
                status.filetype(),
                " ", sep, " ", "%l:%c  %P",
            }
        end
    end

    return table.concat(status_line, "")
end
