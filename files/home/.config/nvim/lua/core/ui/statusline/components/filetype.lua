local plugin = require("utils.plugin")
plugin.load("nvim-web-devicons", "UIEnter")

local filetype_aliases = {
    ["javascript"] = "js",
    ["typescript"] = "ts",
    ["python"]     = "py",
}


return function()
    local ft = vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].filetype

    local icon, icon_hl, color

    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        icon, color = devicons.get_icon_color_by_filetype(ft)
        if icon then
            icon_hl = "StlIcon@" .. ft

            vim.api.nvim_set_hl(0, icon_hl, {
                fg = color,
                bg = "none",
            })

            icon_hl = "%#" .. icon_hl .. "#"

            local format = {
                icon_hl,
                icon,
                "%*",
            }

            return table.concat(format, "")
        end
    end

    return (not ft or ft == "") and "" or (filetype_aliases[ft] or ft)
end
