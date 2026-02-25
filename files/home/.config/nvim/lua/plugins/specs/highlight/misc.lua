return {
    {
        "folke/lsp-colors.nvim",
        event = 'User Ready',
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = 'User Ready',
    },
    {
        "m-demare/hlargs.nvim",
        event = 'User Ready',
    },
    {
        "RRethy/vim-illuminate",
        enabled = false,
        event = 'User Ready',
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
        "norcalli/nvim-colorizer.lua",
        event = 'User Ready',
    },
}
