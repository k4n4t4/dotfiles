return {
    "phaazon/hop.nvim",
    branch = "v2",
    opts = {
        multi_windows = true,
    },
    keys = {
        { mode = 'n', '<LEADER>jj', "<CMD>HopWord<CR>",     desc = "Hop Word" },
        { mode = 'n', '<LEADER>ja', "<CMD>HopAnywhere<CR>", desc = "Hop Anywhere" },
        { mode = 'n', '<LEADER>jl', "<CMD>HopLine<CR>",     desc = "Hop Line" },
        { mode = 'n', '<LEADER>jv', "<CMD>HopVertical<CR>", desc = "Hop Vertical" },
        { mode = 'n', '<LEADER>jc', "<CMD>HopChar1<CR>",    desc = "Hop Char1" },
        { mode = 'n', '<LEADER>j2', "<CMD>HopChar2<CR>",    desc = "Hop Char2" },
        { mode = 'n', '<LEADER>jp', "<CMD>HopPattern<CR>",  desc = "Hop Pattern" },
    },
}
