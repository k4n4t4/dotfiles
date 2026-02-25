local plugin  = require "utils.plugin"
local info    = require "utils.info"
local mapping = require "utils.mapping"

local function get_icon_for_filetype(filetype)
    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        return devicons.get_icon_color_by_filetype(filetype)
    end
    return nil, nil
end

return function()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local ft = info.buf.filetype(bufnr)

    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        local icon, icon_color = get_icon_for_filetype(ft)
        if icon then
            local icon_hl = "StlIcon@" .. ft
            vim.api.nvim_set_hl(0, icon_hl, { fg = icon_color, bg = "none" })
            return "%#" .. icon_hl .. "#" .. icon .. "%*"
        end
    end

    return (not ft or ft == "") and "" or (mapping.filetype_alias.get(ft))
end
