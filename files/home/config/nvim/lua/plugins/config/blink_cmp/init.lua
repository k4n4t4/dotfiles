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
                "lazydev",
                "codecompanion",
                "path",
                "lsp",
                "snippets",
                "obsidian",
                "obsidian_new",
                "obsidian_tags",
                "buffer",
                "calc",
                "git",
                "dictionary",
            },
            providers = {
                lazydev = {
                    name = "LazyDev",
                    module = "lazydev.integrations.blink",
                    score_offset = 700,
                },
                codecompanion = {
                    name = "CodeCompanion",
                    module = "codecompanion.providers.completion.blink",
                    score_offset = 600,
                    async = true,
                },
                path = {
                    module = "blink.cmp.sources.path",
                    name = "Path",
                    score_offset = 513,
                    async = true,
                },
                lsp = {
                    module = "blink.cmp.sources.lsp",
                    name = "LSP",
                    score_offset = 510,
                    async = true,
                    transform_items = function(_, items)
                        if vim.bo.filetype == "java" then
                            return filter_duplicates(items)
                        end

                        return items
                    end,
                },
                snippets = {
                    module = "blink.cmp.sources.snippets",
                    name = "Snip",
                    score_offset = 509,
                    async = true,
                },
                obsidian = {
                    name = "obsidian",
                    module = "blink.compat.source",
                    opts = { name = "obsidian" },
                },
                obsidian_new = {
                    name = "obsidian_new",
                    module = "blink.compat.source",
                    opts = { name = "obsidian_new" },
                },
                obsidian_tags = {
                    name = "obsidian_tags",
                    module = "blink.compat.source",
                    opts = { name = "obsidian_tags" },
                },
                buffer = {
                    module = "blink.cmp.sources.buffer",
                    name = "Buffer",
                    score_offset = 507,
                    async = true,
                },
                calc = {
                    name = "calc",
                    module = "blink.compat.source",
                    score_offset = 300,
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
                        dictionary_files = vim.fn.glob(
                            "/usr/share/dict/*",
                            true,
                            true
                        ),
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
