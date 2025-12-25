local status = require("core.ui.statusline.components")

function StatusLineActive()
    local macro = status.macro_recording()
    local mode = status.mode()
    local file = status.file()
    local flag = status.flag()
    local search = status.search_count()
    local lsp = status.lsp()
    local diagnostic = status.diagnostic()
    local git = status.git()
    local encoding = status.encoding()
    local fileformat = status.fileformat()

    local filetype = status.filetype()

    local status_line = {
        mode,
        " ",
        macro ~= "" and macro .. " " or "",
        file,
        flag,
        " ",
        git,
        " ",
        diagnostic,
        "%=%<",
        "%S",
        " ",
        search,
        lsp,
        " ",
        encoding,
        filetype == "" and "" or " ",
        filetype,
        " ",
        fileformat,
        " ",
        "%l:%c",
        " ",
        "%P",
    }
    return table.concat(status_line, "")
end

function StatusLineInactive()
    local mode = status.mode()
    local file = status.file()
    local flag = status.flag()
    local encoding = status.encoding()
    local fileformat = status.fileformat()
    local filetype = status.filetype()
    local status_line = {
        mode,
        " ",
        file,
        flag,
        "%=%<",
        "%S",
        encoding,
        filetype == "" and "" or " ",
        filetype,
        " ",
        fileformat,
        " ",
        "%l:%c",
        " ",
        "%P",
    }
    return table.concat(status_line, "")
end

function StatusLineSimple()
    local mode = status.mode()
    local filetype = status.filetype()
    local status_line = {
        mode,
        "%=%<",
        filetype .. " ",
    }
    return table.concat(status_line, "")
end

-- TODO: buf...
function StatusLine()
    local current_winid = vim.api.nvim_get_current_win()
    local statusline_winid = vim.g.statusline_winid
    local active = current_winid == statusline_winid
    local statusline_bufnr = vim.api.nvim_win_get_buf(statusline_winid)

    if vim.bo[statusline_bufnr].filetype == "neo-tree" then
        return StatusLineSimple()
    else
        if active then
            return StatusLineActive()
        else
            return StatusLineInactive()
        end
    end
end
