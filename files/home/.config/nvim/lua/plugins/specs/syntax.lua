return {
    {
        "fladson/vim-kitty",
        ft = "kitty",
    },
    {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
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
                file_types = { "markdown", "Avante" },
            }
        end,
    },
    {
        "mattn/emmet-vim",
        ft = { "html", "css", "javascript", "typescript", "typescriptreact", "*.tsx", "*.jsx" },
    },
}
