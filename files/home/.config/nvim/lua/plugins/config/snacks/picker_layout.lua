local M = {}

M.layout = {
    cycle = false,
    preset = function()
        return vim.o.columns >= 120 and "default" or "vertical"
    end,
    layout = { backdrop = false },
    config = function(layout)
        if vim.o.columns >= 120 then
            local main_box = layout.layout
            local input_and_list = layout.layout[1]
            local input = layout.layout[1][1]
            local list = layout.layout[1][2]
            local preview = layout.layout[2]

            main_box.border = "none"
            input_and_list.border = { "┌", "─", "─", "│", "─", "─", "└", "│" }
            input_and_list.width = 0.4
            input.border = "none"
            list.border = "none"
            preview.border = { "", "─", "┐", "│", "┘", "─", "", "" }
            preview.width = 1 - input_and_list.width
        else
            local main_box = layout.layout
            local input = layout.layout[1]
            local list = layout.layout[2]
            local preview = layout.layout[3]

            main_box.border = "single"
            input.border = "none"
            list.border = "none"
            preview.border = { "", "─", "", "", "", "", "", "" }
        end
    end,
}

M.explorer_layout = {
    preset = "sidebar",
    backdrop = false,
    auto_hide = { "input" },
    config = function(layout)
        local input = layout.layout[1]
        local list = layout.layout[2]
        local preview = layout.layout[3]

        input.border = "none"
        list.border = "none"
        preview.border = { "", " ", "", "", "", "", "", "" }
    end,
}

return M
