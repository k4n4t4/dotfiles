local str = require "utils.str"
local tabuf = require "utils.tabuf"

local components = require "core.ui.tabline.components"

local buf_format = components.buf
local tab_format = components.tab

return function()
    local s = ""

    local tabline = ""
    local tab_count = vim.fn.tabpagenr('$')
    local current_tabnr = vim.fn.tabpagenr()
    for tabnr = 1, tab_count do
        tabline = tabline .. tab_format {
            tabnr = tabnr,
            is_current_tab = tabnr == current_tabnr,
        }
    end

    local tabline_width = str.tbl.get_width(tabline)


    local buffer_table = {}
    local bufs = vim.t.bufs or {}
    for _, bufnr in ipairs(bufs) do
        if vim.api.nvim_buf_is_valid(bufnr) then
            table.insert(buffer_table, buf_format(bufnr))
        end
    end

    local buf_widths = {}
    for i, item in ipairs(buffer_table) do
        buf_widths[i] = str.tbl.get_width(item)
    end

    local available_width = vim.o.columns - tabline_width
    local truncate_icon = "%#tabline#" .. "…" .. "%*"
    local truncate_icon_width = str.tbl.get_width(truncate_icon)

    local function calc_last_index(from)
        local w = 0
        local last = from - 1
        local left_icon_w = from > 1 and truncate_icon_width or 0
        for i = from, #buffer_table do
            if w + buf_widths[i] + truncate_icon_width + left_icon_w > available_width then break end
            w = w + buf_widths[i]
            last = i
        end
        return last
    end

    local offset_index = 1
    local last_index = calc_last_index(offset_index)

    local current_bufnr = vim.api.nvim_get_current_buf()
    local buf_index = tabuf.index(current_tabnr, current_bufnr)
    if buf_index and (buf_index < offset_index or buf_index > last_index) then
        local w = 0
        offset_index = buf_index
        for i = buf_index, 1, -1 do
            local left_icon_w = i > 1 and truncate_icon_width or 0
            if w + buf_widths[i] + truncate_icon_width + left_icon_w > available_width then break end
            w = w + buf_widths[i]
            offset_index = i
        end
        last_index = calc_last_index(offset_index)
    end

    local bufline = table.concat(buffer_table, "", offset_index, last_index)
    if offset_index > 1 then bufline = truncate_icon .. bufline end
    if last_index < #buffer_table then bufline = bufline .. truncate_icon end


    s = bufline .. "%#TabLineFill#%=" .. tabline

    return s
end
