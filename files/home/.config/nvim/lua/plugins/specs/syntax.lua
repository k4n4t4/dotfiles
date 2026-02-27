return {
    {
        "fladson/vim-kitty",
        ft = "kitty",
    },
    {
        "MeanderingProgrammer/markdown.nvim",
        ft = "markdown",
        name = "render-markdown",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        },
    },
    {
        "mattn/emmet-vim",
        ft = { "html", "css", "javascript", "typescript", "typescriptreact", "*.tsx", "*.jsx" },
    },
}
