return {
    { -- icons
        "nvim-mini/mini.icons",
        opts = {},
        init = function()
            ---@diagnostic disable-next-line: duplicate-set-field
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    { -- explorer
        "nvim-mini/mini.files",
        event = "VeryLazy",
        config = function()
            local files = require("mini.files")
            files.setup()
            vim.api.nvim_create_autocmd('User', {
                pattern = 'MiniFilesBufferCreate',
                callback = function(args)
                    local b = args.data.buf_id
                    vim.keymap.set('n', '<CR>', function()
                        files.go_in { close_on_file = true }
                    end, { buffer = b, desc = 'Go in' })
                    vim.keymap.set('n', '<S-CR>', files.go_out, { buffer = b, desc = 'Go out' })
                    vim.keymap.set('n', '<Leader>E', files.close, { buffer = b, desc = 'Close' })
                    vim.keymap.set('n', '<ESC>', files.close, { buffer = b, desc = 'Close' })
                end,
            })
        end,
        keys = {
            {
                mode = 'n',
                '<Leader>E',
                '<CMD>lua MiniFiles.open()<CR>',
                desc = 'MiniFiles'
            },
        },
    },
    { -- surround
        "nvim-mini/mini.surround",
        event = "VeryLazy",
        config = function()
            local surround = require("mini.surround")

            surround.setup {
                mappings = {
                    add = 'ys',
                    delete = 'ds',
                    find = '',
                    find_left = '',
                    highlight = '',
                    replace = 'cs',
                    suffix_last = '',
                    suffix_next = '',
                },
                search_method = 'cover_or_next',
            }
            vim.keymap.del('x', 'ys')
            vim.keymap.set('x', 'S', [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })
            vim.keymap.set('n', 'yss', 'ys_', { remap = true })
        end,
    },
    { -- autopairs
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },
    { -- textobjects
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
                n_lines = 500,
                custom_textobjects = {
                    f = spec_treesitter({
                        a = "@function.outer",
                        i = "@function.inner",
                    }),
                    c = spec_treesitter({
                        a = "@class.outer",
                        i = "@class.inner",
                    }),
                    b = spec_treesitter({
                        a = "@block.outer",
                        i = "@block.inner",
                    }),
                    a = spec_treesitter({
                        a = "@parameter.outer",
                        i = "@parameter.inner",
                    }),
                    o = spec_treesitter({
                        a = { "@conditional.outer", "@loop.outer" },
                        i = { "@conditional.inner", "@loop.inner" },
                    }),
                },
            }
        end,
    },
    { -- diff
        "nvim-mini/mini.diff",
        event = "VeryLazy",
        config = function()
            require("mini.diff").setup {
                view = {
                    style = "sign",
                    signs = {
                        add = "┃",
                        change = "┃",
                        delete = "_",
                    },
                    priority = 6,
                },
            }
        end,
    },
    { -- git
        "nvim-mini/mini-git",
        event = "VeryLazy",
        config = function()
            require("mini.git").setup()
        end,
    },
    { -- jump
        "nvim-mini/mini.jump",
        event = "VeryLazy",
        config = function()
            require("mini.jump").setup()
        end,
    },
    { -- jump2d
        "nvim-mini/mini.jump2d",
        event = "VeryLazy",
        config = function()
            require("mini.jump2d").setup()
        end,
    },
}
