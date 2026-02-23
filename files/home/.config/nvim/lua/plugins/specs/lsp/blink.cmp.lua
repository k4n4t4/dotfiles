return {
    "saghen/blink.cmp",
    enabled = false,
    version = '*',
    event = { "InsertEnter", "CmdLineEnter" },
    dependencies = {
        "L3MON4D3/LuaSnip",
        "rafamadriz/friendly-snippets",
        {
            "Kaiser-Yang/blink-cmp-dictionary",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        "giuxtaposition/blink-cmp-copilot",
    },
    config = function()
        require("blink.cmp").setup {
            completion = {
                documentation = {
                    auto_show = true,
                    window = {
                    }
                },
                ghost_text = {
                    enabled = true,
                },
            },
            snippets = {
                preset = "luasnip",
            },
            sources = {
                default = { "snippets", "lsp", "path", "buffer", "dictionary", "copilot" },
                providers = {
                    copilot = {
                        name = "Copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 400,
                        async = true,
                    },
                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                        min_keyword_length = 3,
                        async = true,
                        score_offset = -1000,
                        max_items = 5,
                        opts = {
                            dictionary_files = (function()
                                local dict = "/usr/share/dict/words"
                                if vim.uv.fs_stat(dict) then
                                    return { dict }
                                end
                                return {}
                            end)()
                        },
                    },
                },
            },
            keymap = {
                ['<C-s>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-h>'] = { 'hide', 'fallback' },
                ['<C-e>'] = { 'cancel', 'fallback' },
                ['<C-y>'] = { 'accept', 'fallback' },

                ['<CR>'] = { 'accept', 'fallback' },
                ['<Tab>'] = { 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },

                ['<Left>'] = { 'snippet_backward', 'fallback' },
                ['<Right>'] = { 'snippet_forward', 'fallback' },

                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },

                ['<C-p>'] = { 'show', 'select_prev', 'fallback_to_mappings' },
                ['<C-n>'] = { 'show', 'select_next', 'fallback_to_mappings' },

                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },

                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },
        }

        require("luasnip.loaders.from_vscode").lazy_load()

        local hl = vim.api.nvim_set_hl

        hl(0, "CmpItemAbbr", { fg = "#909090", bg = "none" })
        hl(0, "CmpItemAbbrMatch", { fg = "#3333AA", bg = "none" })
        hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#3399AA", bg = "none" })
    end,
}
