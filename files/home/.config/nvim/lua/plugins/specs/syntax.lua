return {
    {
        "fladson/vim-kitty",
        ft = "kitty",
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = "markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
        config = function()
            require('render-markdown').setup {
                completions = {
                    lsp = {
                        enabled = true,
                    },
                },
            }
        end,
    },
    {
        "mattn/emmet-vim",
        ft = { "html", "css", "javascript", "typescript", "typescriptreact", "*.tsx", "*.jsx" },
    },
}
