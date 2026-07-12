return function(opts)
    local default_props = {
        icon_provider = nil,
        aliases = {
            ["javascript"] = "js",
            ["typescript"] = "ts",
            ["python"]     = "py",
        },
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local ft = vim.api.nvim_get_option_value("filetype", {
        buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
    })

    if not ft or ft == "" then return nil end

    if props.icon_provider == "nvim-web-devicons" then
        local devicons = require("nvim-web-devicons")
        if devicons then
            local icon, icon_color = devicons.get_icon_color_by_filetype(ft)
            if icon then
                local icon_hl = "StlIcon@" .. ft
                vim.api.nvim_set_hl(0, icon_hl, { fg = icon_color, bg = "none" })
                return {
                    hl = icon_hl,
                    content = icon .. " ",
                }
            end
        end
    end

    return props.aliases[ft] or ft
end
