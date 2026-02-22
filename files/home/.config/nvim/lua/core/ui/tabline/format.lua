local info = require "utils.info"
local hi = require "utils.highlight"

function HandleTabClick(tabnr, _, button, _)
    if button == "l" then
        vim.cmd(tabnr .. "tabnext")
    elseif button == "m" then
        vim.cmd(tabnr .. "tabclose")
    end
end

function HandleBufClick(bufnr, _, button, _)
    if button == "l" then
        vim.api.nvim_set_current_buf(bufnr)
    elseif button == "m" then
        vim.api.nvim_buf_delete(bufnr, { force = false })
    end
end

local plugin = require("utils.plugin")
plugin.load("nvim-web-devicons", "UIEnter")
local function get_icon_for_filetype(filetype)
    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        return devicons.get_icon_color_by_filetype(filetype)
    end
    return nil, nil
end

local function buf_format(bufnr)
    local cur_buf = vim.api.nvim_get_current_buf()
    local is_active_buf = (bufnr == cur_buf)
    local name = info.buf.name(bufnr)
    if name == "" then name = "[Untitled]" end
    local filetype = info.buf.filetype(bufnr)

    local icon, icon_color = get_icon_for_filetype(filetype)
    local icon_hl = ""
    if icon then
        local icon_hl_name = (is_active_buf and "TabLineSelIcon" or "TabLineIcon") .. "@" .. filetype
        hi.set(icon_hl_name, {
            fg = icon_color,
            bg = hi.get(is_active_buf and "TabLineSel" or "TabLine").bg,
        })

        icon_hl = "%#" .. icon_hl_name .. "#"
    else
        icon = ""
    end

    local buf_hi = hi.use(is_active_buf and "TabLineSel" or "TabLine")
    local mod = info.buf.modified(bufnr) and " +" or ""
    local ro = info.buf.is_readonly(bufnr) and " R" or ""


    return table.concat({
        "%", bufnr, "@v:lua.HandleBufClick@",
        buf_hi, "[",
        icon_hl, icon, (icon ~= "" and " " or ""),
        buf_hi, name, mod, ro, "]",
        "%X"
    })
end

local function tab_format(opts)
    local tabnr = opts.tabnr
    local is_active_tab = opts.is_current_tab

    local tabpages = vim.api.nvim_list_tabpages()
    local tabpage = tabpages[tabnr]
    if not tabpage then return "" end

    local tab_hi = hi.use(is_active_tab and "TabLineSel" or "TabLine")

    return table.concat({
        "%", tabnr, "@v:lua.HandleTabClick@",
        tab_hi, " ", tostring(tabnr), " ",
        "%X"
    })
end

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
