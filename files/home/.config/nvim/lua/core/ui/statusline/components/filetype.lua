local plugin = require("utils.plugin")
local info = require("utils.info")

plugin.load("nvim-web-devicons", "UIEnter")

local filetype_aliases = {
    ["javascript"] = "js",
    ["typescript"] = "ts",
    ["python"]     = "py",
}

return function()
    local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    local ft = info.buf.filetype(bufnr)

    local devicons = plugin.get("nvim-web-devicons")
    if devicons then
        local icon, color = devicons.get_icon_color_by_filetype(ft)
        if icon then
            local icon_hl = "StlIcon@" .. ft
            vim.api.nvim_set_hl(0, icon_hl, { fg = color, bg = "none" })
            return "%#" .. icon_hl .. "#" .. icon .. "%*"
        end
    end

    return (not ft or ft == "") and "" or (filetype_aliases[ft] or ft)
end
