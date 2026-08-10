return {
    --[[ EDITING PLUGINS ]]--

    -- icons
    {
        "nvim-mini/mini.icons",
        opts = {},
        init = function()
            --- @diagnostic disable-next-line: duplicate-set-field
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
    -- explorer
    {
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
                    vim.keymap.set('n', '<Leader>e', files.close, { buffer = b, desc = 'Close' })
                    vim.keymap.set('n', '<ESC>', files.close, { buffer = b, desc = 'Close' })
                end,
            })
        end,
        keys = {
            {
                mode = 'n',
                '<Leader>-',
                '<CMD>lua MiniFiles.open()<CR>',
                desc = 'MiniFiles toggle'
            },
        },
    },
    -- surround
    {
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
    -- autopairs
    {
        "nvim-mini/mini.pairs",
        event = "InsertEnter",
        config = function()
            require("mini.pairs").setup()
        end,
    },
    -- textobjects
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
    -- git
    {
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
    {
        "nvim-mini/mini-git",
        event = "VeryLazy",
        config = function()
            require("mini.git").setup()
        end,
    },
    -- jump
    {
        "nvim-mini/mini.jump",
        event = "VeryLazy",
        config = function()
            require("mini.jump").setup()
        end,
    },
    {
        "nvim-mini/mini.jump2d",
        event = "VeryLazy",
        config = function()
            require("mini.jump2d").setup()
        end,
    },

    --[[ UI PLUGINS ]]--

    -- themes
    {
        "nvim-mini/mini.base16",
        lazy = false,
        config = function()
            require('mini.base16').setup {
                palette = {
                    base00 = "#202020",
                    base01 = "#272727",
                    base02 = "#2F2F2F",
                    base03 = "#606060",
                    base04 = "#676767",
                    base05 = "#A0A0A0",
                    base06 = "#B0B0B0",
                    base07 = "#C0C0C0",
                    base08 = "#C05050",
                    base09 = "#C07050",
                    base0A = "#C09000",
                    base0B = "#70C070",
                    base0C = "#50C0C0",
                    base0D = "#5090C0",
                    base0E = "#C090C0",
                    base0F = "#D0D0D0",
                },
                use_cterm = true,
                plugins = {
                    default = false,
                    ["saghen/blink.cmp"] = true,
                },
            }
            vim.api.nvim_exec_autocmds('ColorScheme', {})
        end,
    },
}
