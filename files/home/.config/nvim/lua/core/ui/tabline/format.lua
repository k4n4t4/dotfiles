local buf_format = require "core.ui.tabline.components.buf"
local tab_format = require "core.ui.tabline.components.tab"

function TabLine()
    local s = ""

    local bufs = vim.t.bufs or {}
    for _, bufnr in ipairs(bufs) do
        if vim.api.nvim_buf_is_valid(bufnr) then
            s = s .. buf_format(bufnr)
        end
    end

    s = s .. "%#TabLineFill#%="

    local tab_count = vim.fn.tabpagenr('$')
    local current_tabnr = vim.fn.tabpagenr()
    for tabnr = 1, tab_count do
        s = s .. tab_format {
            tabnr = tabnr,
            is_current_tab = tabnr == current_tabnr,
        }
    end

    return s
end
