local status = require("core.ui.statusline.components")

function StatusLine()
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
                status.macro_recording(), " ",
                status.file(),
                status.flag(), " ",
                status.git(), " ",
                status.diagnostic(),
                "%=%<",
                "%S", " ",
                status.search_count(),
                status.lsp(), " ",
                status.encoding(), " ",
                status.filetype(), " ",
                status.fileformat(), " ",
                "%l:%c", " ",
                "%P",
            }
        else
            status_line = {
                status.mode(), " ",
                status.file(),
                status.flag(),
                "%=%<",
                "%S",
                status.encoding(), " ",
                status.filetype(), " ",
                status.fileformat(), " ",
                "%l:%c", " ",
                "%P",
            }
        end
    end

    return table.concat(status_line, "")
end
