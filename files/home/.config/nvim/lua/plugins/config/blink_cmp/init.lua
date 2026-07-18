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

    local loader = require("luasnip.loaders.from_vscode")
    loader.lazy_load()
    loader.lazy_load { paths = { vim.fn.stdpath("config") .. "/snippets" } }

    ---@diagnostic disable-next-line: undefined-field
    local winblend = vim.opt.winblend:get() or 0

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
            sources = function()
                local type = vim.fn.getcmdtype()
                if type == "/" or type == "?" then return { "buffer" } end
                if type == ":" then return { "cmdline" } end
                return {}
            end,
            completion = {
                list = { selection = { preselect = false } },
                menu = { auto_show = true },
            },
        },
        sources = {
            default = { "copilot", "avante", "codecompanion", "path", "lsp", "snippets", "obsidian", "obsidian_new", "obsidian_tags", "buffer", "calc", "emoji", "git", "dictionary" },
            providers = {
                copilot = {
                    name = "Copilot",
                    module = "blink-cmp-copilot",
                    score_offset = 600,
                    async = true,
                },
                avante = {
                    name = "Avante",
                    module = "blink-cmp-avante",
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

    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { link = "Comment" })
end

return M
