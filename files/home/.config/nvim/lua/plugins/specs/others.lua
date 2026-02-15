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
        event = 'VeryLazy',
    },
    {
        "RRethy/vim-illuminate",
        enabled = false,
        event = 'VeryLazy',
        config = function()
            local illuminate = require("illuminate")
            illuminate.configure {
                providers = {
                    'lsp',
                    'treesitter',
                    'regex',
                },
                delay = 500,
                filetype_overrides = {},
                filetypes_denylist = {
                    'dirbuf',
                    'dirvish',
                    'fugitive',
                },
                filetypes_allowlist = {},
                modes_denylist = {},
                modes_allowlist = {},
                providers_regex_syntax_denylist = {},
                providers_regex_syntax_allowlist = {},
                under_cursor = true,
                large_file_cutoff = nil,
                large_file_overrides = nil,
                min_count_to_highlight = 1,
                should_enable = function() return true end,
                case_insensitive_regex = false,
            }
        end,
    },
    {
        "nvim-tree/nvim-web-devicons",
        event = 'VeryLazy',
    },
    {
        "norcalli/nvim-colorizer.lua",
        event = 'VeryLazy',
    },
}
