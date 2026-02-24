local info = require "utils.info"
local hi = require "utils.highlight"

local plugin = require("utils.plugin")
plugin.load("nvim-web-devicons", "UIEnter")
local function get_icon_for_filetype(filetype)
    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        return devicons.get_icon_color_by_filetype(filetype)
    end
    return nil, nil
end

function HandleBufClick(bufnr, _, button, _)
    if button == "l" then
        vim.api.nvim_set_current_buf(bufnr)
    elseif button == "m" then
        vim.api.nvim_buf_delete(bufnr, { force = false })
    end
end

return function(bufnr)
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

    local sep_hi_name = (is_active_buf and "TabLineSelInv" or "TabLineInv") .. "@" .. filetype
    hi.set(sep_hi_name, {
        fg = hi.get(is_active_buf and "TabLineSel" or "TabLine").bg,
        bg = hi.get("TabLineFill").bg,
    })
    local sep_hi = "%#" .. sep_hi_name .. "#"

    return table.concat({
        "%", bufnr, "@v:lua.HandleBufClick@",
        sep_hi, "🮋", buf_hi,
        icon_hl, icon, (icon ~= "" and " " or ""),
        buf_hi, name, mod, ro,
        sep_hi, "▉", buf_hi,
        "%X"
    })
end
