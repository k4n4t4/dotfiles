return {
    {
        "nvim-mini/mini.files",
        event = "VeryLazy",
        config = function()
            require("mini.files").setup()
        end,
        keys = {
            {
                mode = 'n',
                '<Leader>-',
                '<CMD>lua MiniFiles.open()<CR>',
                desc = 'Oil'
            },
        },
    },
    {
        "nvim-mini/mini.surround",
        config = function()
            local surround = require("mini.surround")

            local prefix = 'y'
            surround.setup {
                mappings = {
                    add = prefix .. 's',
                    delete = prefix .. 'd',
                    find = prefix .. 'f',
                    find_left = prefix .. 'F',
                    highlight = prefix .. 'h',
                    replace = prefix .. 'r',
                    suffix_last = '',
                    suffix_next = '',
                },
            }
            vim.keymap.del('x', 'ys')
            vim.keymap.del('x', 'yf')
            vim.keymap.del('x', 'yF')
            vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
        end,
    },
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },
    {
        "nvim-mini/mini.ai",
        dependencies = {
            {
                "nvim-treesitter/nvim-treesitter-textobjects",
                dependencies = { "nvim-treesitter/nvim-treesitter" },
            },
        },
        event = "VeryLazy",
        config = function()
            local ai = require("mini.ai")
            local spec_treesitter = ai.gen_spec.treesitter
            ai.setup {
                custom_textobjects = {
                    f = spec_treesitter {
                        a = "@function.outer",
                        i = "@function.inner",
                    },
                    c = spec_treesitter {
                        a = "@class.outer",
                        i = "@class.inner",
                    },
                    b = spec_treesitter {
                        a = "@block.outer",
                        i = "@block.inner",
                    },
                    a = spec_treesitter {
                        a = "@parameter.outer",
                        i = "@parameter.inner",
                    },
                    o = spec_treesitter {
                        a = {
                            "@conditional.outer",
                            "@loop.outer",
                        },
                        i = {
                            "@conditional.inner",
                            "@loop.inner",
                        },
                    },
                },
            }
        end,
    },
}
