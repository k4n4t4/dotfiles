return {
    "saghen/blink.cmp",
    version = '*',
    dependencies = {
        {
            "L3MON4D3/LuaSnip",
            dependencies = { "rafamadriz/friendly-snippets" },
            config = function()
                local loader = require("luasnip.loaders.from_vscode")
                loader.lazy_load()
                loader.lazy_load {
                    paths = { vim.fn.stdpath("config") .. "/snippets" }
                }
            end,
        },
        {
            "Kaiser-Yang/blink-cmp-dictionary",
            dependencies = { "nvim-lua/plenary.nvim" },
        },
        "giuxtaposition/blink-cmp-copilot",
        'brenoprata10/nvim-highlight-colors',
        "moyiz/blink-emoji.nvim",
        {
            "xzbdmw/colorful-menu.nvim",
            dependencies = { "nvim-treesitter/nvim-treesitter" },
            config = function()
                require("colorful-menu").setup {}
            end,
        },
        'Kaiser-Yang/blink-cmp-git',

        {
            "saghen/blink.compat",
            version = false,
        },
        "hrsh7th/cmp-calc",
    },
    event = { "InsertEnter", "CmdLineEnter" },
    config = function()
        require("blink.cmp").setup {
            fuzzy = { implementation = "prefer_rust_with_warning" },
            signature = {
                enabled = true,
                window = {
                    winblend = 10,
                    show_documentation = true,
                }
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono',
            },
            completion = {
                list = { selection = { preselect = false } },
                ghost_text = { enabled = true },
                documentation = {
                    auto_show = true,
                    window = {
                        winblend = 10,
                    },
                },
                menu = {
                    max_height = 10,
                    winblend = 10,
                    draw = {
                        columns = { { "kind_icon" }, { "label", gap = 1 } },
                        components = {
                            label = {
                                width = { fill = true, max = 60 },
                                text = function(ctx)
                                    local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                    if highlights_info ~= nil then
                                        return highlights_info.label
                                    else
                                        return ctx.label
                                    end
                                end,
                                highlight = function(ctx)
                                    local highlights = {}
                                    local highlights_info = require("colorful-menu").blink_highlights(ctx)
                                    if highlights_info ~= nil then
                                        highlights = highlights_info.highlights
                                    end
                                    for _, idx in ipairs(ctx.label_matched_indices) do
                                        table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                                    end
                                    return highlights
                                end,
                            },
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if ctx.item.source_name == "LSP" then
                                        local color_item = require("nvim-highlight-colors").format(
                                            ctx.item.documentation,
                                            { kind = ctx.kind })
                                        if color_item and color_item.abbr ~= "" then
                                            icon = color_item.abbr
                                        end
                                    end
                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local highlight = "BlinkCmpKind" .. ctx.kind
                                    if ctx.item.source_name == "LSP" then
                                        local color_item = require("nvim-highlight-colors").format(
                                            ctx.item.documentation,
                                            { kind = ctx.kind })
                                        if color_item and color_item.abbr_hl_group then
                                            highlight = color_item.abbr_hl_group
                                        end
                                    end
                                    return highlight
                                end,
                            },
                        },
                    },
                },
            },
            snippets = {
                preset = "luasnip",
            },
            cmdline = {
                enabled = true,
                sources = function()
                    local type = vim.fn.getcmdtype()
                    if type == "/" or type == "?" then
                        return { "buffer" }
                    end
                    if type == ":" then
                        return { "cmdline" }
                    end
                    return {}
                end,
                keymap = {
                    preset = "cmdline",
                    ["<Right>"] = false,
                    ["<Left>"] = false,
                },
                completion = {
                    list = { selection = { preselect = false } },
                    menu = {
                        auto_show = function(_)
                            return vim.fn.getcmdtype() == ":"
                        end,
                    },
                    ghost_text = { enabled = true },
                },
            },
            sources = {
                default = {
                    "copilot",
                    "snippets",
                    "lsp",
                    "path",
                    "calc",
                    "emoji",
                    "buffer",
                    "git",
                    "dictionary",
                },
                providers = {
                    copilot = {
                        name = "Copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 700,
                        async = true,
                    },
                    snippets = {
                        module = "blink.cmp.sources.snippets",
                        name = "Snip",
                        score_offset = 600,
                        async = true,
                    },
                    lsp = {
                        module = "blink.cmp.sources.lsp",
                        name = "LSP",
                        score_offset = 500,
                        async = true,
                    },
                    path = {
                        module = "blink.cmp.sources.path",
                        name = "Path",
                        score_offset = 400,
                        async = true,
                    },
                    calc = {
                        name = "calc",
                        module = "blink.compat.source",
                        score_offset = 300,
                        async = true,
                    },
                    emoji = {
                        module = "blink-emoji",
                        name = "Emoji",
                        score_offset = 200,
                        opts = {
                            insert = true,
                            trigger = function()
                                return { ":" }
                            end,
                        },
                        async = true,
                    },
                    buffer = {
                        module = "blink.cmp.sources.buffer",
                        name = "Buffer",
                        score_offset = 100,
                        async = true,
                    },
                    git = {
                        module = 'blink-cmp-git',
                        name = 'Git',
                        enabled = function()
                            return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
                        end,
                        score_offset = 0,
                        async = true,
                        opts = {},
                    },
                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                        min_keyword_length = 3,
                        async = true,
                        score_offset = 0,
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
                ['<C-c>'] = { 'show', 'show_documentation', 'hide_documentation' },
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

                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },
        }

        local hl = vim.api.nvim_set_hl
        hl(0, "BlinkCmpGhostText", { link = "Comment" })
    end,
}
