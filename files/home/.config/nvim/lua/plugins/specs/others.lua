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
        event = 'VeryLazy',
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = 'VeryLazy',
    },
    {
        "m-demare/hlargs.nvim",
        config = function() require("hlargs").setup() end,
        event = 'VeryLazy',
    },
    {
        "nvim-tree/nvim-web-devicons",
        event = 'VeryLazy',
    },
    {
        "norcalli/nvim-colorizer.lua",
        config = function() require("colorizer").setup() end,
        cmd = { "ColorizerToggle", "ColorizerAttachToBuffer", "ColorizerDetachFromBuffer", "ColorizerReloadAllBuffers" },
    },
}
