return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-emoji",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-git",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/cmp-calc",
            "yutkat/cmp-mocword",
            "onsails/lspkind.nvim",
            "nvimtreesitter/nvim-treesitter",
            "ray-x/cmp-treesitter",
            "zbirenbaum/copilot-cmp",
            "saadparwaiz1/cmp_luasnip",
            {
                "L3MON4D3/LuaSnip",
                build = "make install_jsregexp",
            },
            "rafamadriz/friendly-snippets",
        },
        config = function()
            local cmp = require "cmp"
            local lspkind = require "lspkind"
            local luasnip = require "luasnip"

            cmp.setup {
                formatting = {
                    fields = { "abbr", "icon", "kind", "menu" },
                    format = function(entry, vim_item)
                        local kind = lspkind.cmp_format {
                            mode = "symbol_text",
                            maxwidth = 50,
                            menu = {
                                copilot       = "Copilot",
                                string        = "String",
                                buffer        = "Buffer",
                                nvim_lsp      = "LSP",
                                nvim_lua      = "Lua",
                                luasnip       = "Snip",
                                latex_symbols = "Latex",
                                calc          = "Calc",
                                path          = "Path",
                                git           = "Git",
                                emoji         = "Emoji",
                            },
                        }(entry, vim_item)

                        return kind
                    end,
                },
                window = {
                    completion = {
                        -- border = { '┌', '─', '┐', '│', '┘', '─', '└', '│' };
                        side_padding = 0,
                        col_offset = 0,
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                        winblend = 10,
                    },
                    documentation = {
                        -- border = { '╔', '═', '╗', '║', '╝', '═', '╚', '║' };
                        side_padding = 0,
                        col_offset = 0,
                        winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel,Search:None",
                        winblend = 10,
                    },
                },
                experimental = {
                    ghost_text = false,
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                sources = {
                    { name = 'copilot' },
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'nvim_lua' },
                    { name = 'path' },
                    { name = 'git' },
                    { name = 'calc' },
                    { name = 'treesitter' },
                    { name = 'emoji' },
                    { name = 'mocword' },
                    { name = 'buffer' },
                },
                mapping = cmp.mapping.preset.insert {
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<S-TAB>'] = cmp.mapping.select_prev_item(),
                    ['<TAB>'] = cmp.mapping.select_next_item(),
                    ['<CR>'] = cmp.mapping.confirm({ select = false }),
                },
            }

            cmp.setup.cmdline({ '/', '?' }, {
                sources = cmp.config.sources {
                    { name = 'buffer' },
                },
                mapping = cmp.mapping.preset.cmdline(),
            })

            cmp.setup.cmdline({ ':', '@', '-', '=', '>' }, {
                sources = cmp.config.sources {
                    { name = 'path' },
                    { name = 'cmdline' },
                    { name = 'buffer' },
                },
                mapping = cmp.mapping.preset.cmdline(),
                matching = { disallow_symbol_nonprefix_matching = false }
            })


            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

            require("luasnip.loaders.from_vscode").lazy_load()


            local hl = vim.api.nvim_set_hl

            hl(0, "CmpItemAbbr", { fg = "#909090", bg = "none" })
            hl(0, "CmpItemAbbrMatch", { fg = "#3333AA", bg = "none" })
            hl(0, "CmpItemAbbrMatchFuzzy", { fg = "#3399AA", bg = "none" })
        end,
        event = {
            'InsertEnter',
            'CmdlineEnter',
        },
        cmd = "CmpStatus",
    }
}
