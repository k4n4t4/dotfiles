local filetype_aliases = {
    ["javascript"] = "js";
    ["typescript"] = "ts";
    ["python"]     = "py";
}

local devicons
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        local result, ret = pcall(require, "nvim-web-devicons")
        if result then
            devicons = ret
        end
    end
})

return function()
    local ft = vim.bo[vim.api.nvim_win_get_buf(vim.g.statusline_winid)].filetype

    local icon, icon_hl, color
    if devicons then
        if devicons
        then
            icon, color = devicons.get_icon_color_by_filetype(ft)
            if icon then
                icon_hl = "StlIcon@" .. ft

                vim.api.nvim_set_hl(0,icon_hl, {
                    fg = color;
                    bg = "none";
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
    end

    return (not ft or ft == "") and "" or (filetype_aliases[ft] or ft)
end
