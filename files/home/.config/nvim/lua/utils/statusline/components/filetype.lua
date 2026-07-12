return function(opts)
    local default_props = {
        aliases = {
            ["javascript"] = "js",
            ["typescript"] = "ts",
            ["python"]     = "py",
        },
    }
    local props = opts and vim.tbl_deep_extend("force", default_props, opts) or default_props

    local ft = require("utils.info").buf.filetype(vim.api.nvim_win_get_buf(vim.g.statusline_winid))
    if not ft or ft == "" then
        return nil
    end

    local devicons = require("utils.plugin").get("nvim-web-devicons")
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

    local fallback = props.aliases[ft]
    if not fallback or fallback == "" then
        return nil
    end

    return fallback
end
