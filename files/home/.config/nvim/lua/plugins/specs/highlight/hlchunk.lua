return {
    "shellRaining/hlchunk.nvim",
    config = function()
        require("hlchunk").setup {
            chunk = {
                enable = true,
                style = {
                    { fg = "#22A0A0" },
                    { fg = "#CC2233" },
                },
                use_treesitter = true,
                chars = {
                    horizontal_line = "─",
                    vertical_line = "│",
                    left_top = "┌",
                    left_bottom = "└",
                    right_arrow = ">",
                },
                textobject = "",
                max_file_size = 1024 * 1024,
                error_sign = true,
                delay = 0,
            },
            indent = {
                enable = false,
            },
        }
    end,
    event = 'VeryLazy',
}
