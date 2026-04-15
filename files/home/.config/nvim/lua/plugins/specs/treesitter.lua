return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        branch = "main",
        event = 'User Ready',
        init = function()
            vim.g.no_plugin_maps = true
        end,
        config = function()
            require("nvim-treesitter-textobjects").setup { select = { lookahead = true } }

            local map = vim.keymap.set

            map({ "x", "o" }, "af", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.outer", "textobjects")
            end)
            map({ "x", "o" }, "if", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@function.inner", "textobjects")
            end)
            map({ "x", "o" }, "ac", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.outer", "textobjects")
            end)
            map({ "x", "o" }, "ic", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@class.inner", "textobjects")
            end)
            map({ "x", "o" }, "ab", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@block.outer", "textobjects")
            end)
            map({ "x", "o" }, "ib", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@block.inner", "textobjects")
            end)
            map({ "x", "o" }, "aa", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@parameter.outer", "textobjects")
            end)
            map({ "x", "o" }, "ia", function()
                require "nvim-treesitter-textobjects.select".select_textobject("@parameter.inner", "textobjects")
            end)
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = 'User Ready',
        config = function()
            require("treesitter-context").setup { enable = true }
            local hi = require "utils.highlight"
            hi.set("TreesitterContext", { bg = hi.ref("WinSeparator", "fg") })
        end,
    },
}
