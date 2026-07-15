return {
    --[[ EDITING PLUGINS ]]--

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
                custom_textobjects = {
                    f = spec_treesitter { a = "@function.outer", i = "@function.inner" },
                    c = spec_treesitter { a = "@class.outer", i = "@class.inner" },
                    b = spec_treesitter { a = "@block.outer", i = "@block.inner" },
                    a = spec_treesitter { a = "@parameter.outer", i = "@parameter.inner" },
                    o = spec_treesitter {
                        a = { "@conditional.outer", "@loop.outer" },
                        i = { "@conditional.inner", "@loop.inner" },
                    },
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
        event = "VeryLazy",
        config = function()
            require('mini.base16').setup {
                palette = {
                    base00 = "#10101f",
                    base01 = "#2a2a2f",
                    base02 = "#40404f",
                    base03 = "#5a5a5f",
                    base04 = "#70707f",
                    base05 = "#a0a0b0",
                    base06 = "#b0b0c0",
                    base07 = "#c0c0d0",
                    base08 = "#c05050",
                    base09 = "#c07050",
                    base0A = "#c09000",
                    base0B = "#70c070",
                    base0C = "#50c090",
                    base0D = "#5090c0",
                    base0E = "#c090c0",
                    base0F = "#900000",
                },
                use_cterm = true,
                plugins = { default = false },
            }
        end,
    },
    -- highlight patterns
    {
        "nvim-mini/mini.hipatterns",
        dependencies = {
            "nvim-mini/mini.extra"
        },
        event = "VeryLazy",
        config = function()
            local hipatterns = require('mini.hipatterns')
            local hi_words = require('mini.extra').gen_highlighter.words
            hipatterns.setup({
                highlighters = {
                    fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
                    hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
                    todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
                    note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
                    hex_color = hipatterns.gen_highlighter.hex_color(),
                },
            })
        end,
    },
}
