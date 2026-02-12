-- require "core.ui.tabline.highlights"
-- require "core.ui.tabline.format"
--
-- vim.opt.showtabline = 2
-- vim.opt.tabline = "%!v:lua.TabLine()"


local hi = require "utils.highlight"
local info = require "utils.info"
local plugin = require("utils.plugin")

plugin.load("nvim-web-devicons", "UIEnter")

local hls = {
    {"TabLine", {
        fg = "none",
        bg = "#202020",
    }},
    {"TabLineFill", {
        fg = "none",
        bg = "#111111",
    }},
    {"TabLineFileName", {
        fg = "#A0A0A0",
        bg = "#202020",
    }},
    {"TabLineUntitled", {
        fg = "#707070",
        bg = "#202020",
        italic = true,
    }},
    {"CurrentTabLine", {
        fg = "none",
        bg = "#404040",
    }},
    {"CurrentTabLineFileName", {
        fg = "#E0E0E0",
        bg = "#404040",
    }},
    {"CurrentTabLineUntitled", {
        fg = "#909090",
        bg = "#404040",
        italic = true,
    }},
}
for _, v in pairs(hls) do
    hi.set(v[1], v[2])
end

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

local function buf_format(bufnr, is_active_tab)
    local cur_buf = vim.api.nvim_get_current_buf()
    local is_buf_active = (bufnr == cur_buf)
    local name = info.buf.name(bufnr)
    local filetype = info.buf.filetype(bufnr)
    local is_untitled = (name == "[No Name]")

    local hl_prefix = is_active_tab and "CurrentTabLine" or "TabLine"
    local hl_suffix = is_untitled and "Untitled" or "FileName"
    local base_bg = is_active_tab and "#404040" or "#202020"

    local icon = ""
    local icon_hl = ""

    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        local color
        icon, color = devicons.get_icon_color_by_filetype(filetype)
        if icon then
            local hl_name = (is_active_tab and "Current" or "") .. "TabLineIcon@" .. filetype
            vim.api.nvim_set_hl(0, hl_name, {
                fg = color,
                bg = base_bg,
            })
            icon_hl = "%#" .. hl_name .. "#"
        else
            icon = ""
        end
    end

    local buf_hi = is_buf_active and "%#" .. hl_prefix .. hl_suffix .. "#" or "%#" .. hl_prefix .. "#"
    local mod = info.buf.modified(bufnr) and " +" or ""
    local ro = info.buf.is_readonly(bufnr) and " R" or ""

    return icon_hl .. icon .. buf_hi .. "%" .. bufnr .. "@v:lua.HandleBufClick@[" .. name .. mod .. ro .. "]%X"
end

local function tab_format(opts)
    local s = ""
    local tabpages = vim.api.nvim_list_tabpages()
    local tabpage = tabpages[opts.tabnr]
    if not tabpage then return s end

    local is_active = opts.is_current_tab
    local bufs = info.tab.buflist(tabpage)
    local tab_hi = is_active and "%#CurrentTabLine#" or "%#TabLine#"

    s = s .. tab_hi .. "%" .. opts.tabnr .. "@v:lua.HandleTabClick@" .. " <tab" .. opts.tabnr .. " "

    for _, bufnr in ipairs(bufs) do
        if info.buf.is_real_file(bufnr) then
            s = s .. buf_format(bufnr, is_active)
        end
    end

    s = s .. tab_hi .. "%X> "
    return s
end

function TabLine()
    local s = ""
    local all_tab_bufs = {}
    local tab_count = vim.fn.tabpagenr('$')
    local current_tabnr = vim.fn.tabpagenr()
    local tabpages = vim.api.nvim_list_tabpages()

    for tabnr = 1, tab_count do
        s = s .. tab_format {
            tabnr = tabnr,
            is_current_tab = tabnr == current_tabnr,
        }

        local tabpage = tabpages[tabnr]
        if tabpage then
            for _, b in ipairs(info.tab.buflist(tabpage)) do
                all_tab_bufs[b] = true
            end
        end
    end

    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        if info.buf.is_real_file(bufnr) and not all_tab_bufs[bufnr] then
            s = s .. buf_format(bufnr, false) .. " "
        end
    end

    s = s .. "%#TabLineFill#%="
    return s
end


vim.opt.showtabline = 2
vim.opt.tabline = "%!v:lua.TabLine()"
