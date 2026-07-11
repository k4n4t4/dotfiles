return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
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

    { "fladson/vim-kitty", ft = "kitty" },

    {
        "mattn/emmet-vim",
        ft = { "html", "css", "javascript", "typescript", "typescriptreact", "*.tsx", "*.jsx" },
    },

    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require('render-markdown').setup {
                completions = {
                    lsp = {
                        enabled = true,
                    },
                },
                latex = {
                    enabled = false,
                },
                file_types = { "markdown", "Avante" },
            }
        end,
    },
}
