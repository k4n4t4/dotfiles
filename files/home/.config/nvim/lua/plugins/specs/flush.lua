return {
    "folke/flash.nvim",
    keys = {
        { mode = "n", "f" },
        { mode = "n", "F" },
        { mode = "n", "t" },
        { mode = "n", "T" },
        { mode = { "n", "x", "o" }, "<Leader>ff", function() require("flash").jump() end,              desc = "Flash" },
        { mode = { "n", "x", "o" }, "<Leader>ft", function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
        { mode = "o",               "<Leader>fr", function() require("flash").remote() end,            desc = "Remote Flash" },
        { mode = { "o", "x" },      "<Leader>fR", function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
        { mode = { "c" },           "<C-s>",      function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
    },
    opts = {},
}
