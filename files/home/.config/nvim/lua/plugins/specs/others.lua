return {
    -- highlights
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
    {
        "leafgarland/typescript-vim",
        ft = { "typescript", "typescriptreact", "*.tsx", "*.jsx" },
    },
    {
        "peitalin/vim-jsx-typescript",
        ft = { "typescript", "typescriptreact", "*.tsx", "*.jsx" },
    },
    {
        "folke/lsp-colors.nvim",
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },
    {
        "m-demare/hlargs.nvim",
    },
    {
        "nvim-tree/nvim-web-devicons",
        event = 'VeryLazy',
    },
    {
        "norcalli/nvim-colorizer.lua",
    },
}
