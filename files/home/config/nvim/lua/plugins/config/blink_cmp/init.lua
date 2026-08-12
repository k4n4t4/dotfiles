local M = {}

local function filter_duplicates(items)
    local seen = {}
    local filtered = {}

    for _, item in ipairs(items) do
        if item.kind == 2 or item.kind == 3 then
            local method_name = item.label:match("^([^%(]+)")
            if method_name then
                if not seen[method_name] then
                    seen[method_name] = true
                    table.insert(filtered, item)
                end
            else
                table.insert(filtered, item)
            end
        else
            table.insert(filtered, item)
        end
    end

    return filtered
end

function M.config()
    vim.opt.autocomplete = false

    local winblend = vim.o.winblend

    require("blink.cmp").setup {
        fuzzy = { implementation = "prefer_rust_with_warning" },
        signature = {
            enabled = true,
            window = { winblend = winblend, show_documentation = true }
        },
        completion = {
            list = { selection = { preselect = false } },
            documentation = { auto_show = true, window = { winblend = winblend } },
            menu = {
                winblend = winblend,
                draw = {
                    columns = { { "kind_icon" }, { "label", gap = 1 } },
                    components = {
                        label = {
                            text = function(ctx)
                                return require("colorful-menu").blink_components_text(ctx)
                            end,
                            highlight = function(ctx)
                                return require("colorful-menu").blink_components_highlight(ctx)
                            end,
                        },
                    },
                },
            },
        },
        cmdline = {
            enabled = true,
            keymap = {
                preset = "inherit",
            },
            completion = {
                list = { selection = { preselect = false } },
                menu = { auto_show = true },
            },
        },
        sources = {
            default = {
                "lsp",
                "snippets",
                "path",
                "buffer",
                "lazydev",
                "calc",
                "git",
                "dictionary",
                "codecompanion",
                "obsidian",
                "obsidian_new",
                "obsidian_tags",
            },
            providers = {
                lsp = {
                    name = "LSP",
                    module = "blink.cmp.sources.lsp",
                    score_offset = 50,
                    async = true,
                    transform_items = function(_, items)
                        if vim.bo.filetype == "java" then
                            return filter_duplicates(items)
                        end
                        return items
                    end,
                },
                snippets = {
                    name = "Snip",
                    module = "blink.cmp.sources.snippets",
                    score_offset = 30,
                    async = true,
                },
                path = {
                    name = "Path",
                    module = "blink.cmp.sources.path",
                    score_offset = 20,
                    async = true,
                },
                buffer = {
                    name = "Buffer",
                    module = "blink.cmp.sources.buffer",
                    score_offset = 10,
                    async = true,
                },
                calc = {
                    name = "Calc",
                    module = "blink.compat.source",
                    score_offset = 0,
                    async = true,
                },
                git = {
                    name = 'Git',
                    module = 'blink-cmp-git',
                    enabled = function()
                        return vim.tbl_contains({ 'octo', 'gitcommit', 'markdown' }, vim.bo.filetype)
                    end,
                    score_offset = 0,
                    async = true,
                    opts = {},
                },
                dictionary = {
                    name = "Dict",
                    module = "blink-cmp-dictionary",
                    min_keyword_length = 3,
                    async = true,
                    score_offset = -10,
                    max_items = 5,
                    opts = {
                        dictionary_files = vim.fn.glob(
                            "/usr/share/dict/*",
                            true,
                            true
                        ),
                    },
                },

                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 100,
                },
                codecompanion = {
                    name = "CodeCompanion",
                    module = "codecompanion.providers.completion.blink",
                    score_offset = 100,
                    async = true,
                },
                obsidian = {
                    name = "Obsidian",
                    module = "blink.compat.source",
                    score_offset = 100,
                    opts = { name = "obsidian" },
                },
                obsidian_new = {
                    name = "ObsidianNew",
                    module = "blink.compat.source",
                    score_offset = 100,
                    opts = { name = "obsidian_new" },
                },
                obsidian_tags = {
                    name = "ObsidianTags",
                    module = "blink.compat.source",
                    score_offset = 100,
                    opts = { name = "obsidian_tags" },
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

            ['<Right>'] = { 'snippet_forward', 'fallback' },
            ['<Left>'] = { 'snippet_backward', 'fallback' },

            ['<Down>'] = { 'select_next', 'fallback' },
            ['<Up>'] = { 'select_prev', 'fallback' },

            ['<C-n>'] = { 'snippet_forward', 'show', 'select_next', 'fallback_to_mappings' },
            ['<C-p>'] = { 'snippet_backward', 'show', 'select_prev', 'fallback_to_mappings' },

            ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },
            ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },

            ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
        },
    }
end

return M
