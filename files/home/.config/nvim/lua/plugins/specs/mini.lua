return {
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
                    vim.keymap.set('n', '<CR>', files.go_in, { buffer = b, desc = 'Go in' })
                    vim.keymap.set('n', '<S-CR>', files.go_out, { buffer = b, desc = 'Go out' })
                    vim.keymap.set('n', '<Leader>e', files.close, { buffer = b, desc = 'Close' })
                end,
            })
        end,
        keys = {
            {
                mode = 'n',
                '<Leader>e',
                '<CMD>lua MiniFiles.open()<CR>',
                desc = 'MiniFiles toggle'
            },
        },
    },
    {
        "nvim-mini/mini.surround",
        event = "VeryLazy",
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
    {
        "nvim-mini/mini.diff",
        event = "User Ready",
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
        event = "User Ready",
        config = function()
            require("mini.git").setup()
        end,
    },
    {
        "nvim-mini/mini.pick",
        event = "User Ready",
        config = function()
            local pick = require("mini.pick")
            pick.setup()
            vim.ui.select = pick.ui_select
            vim.keymap.set('n', '<space>ff', function()
                pick.builtin.files({ tool = 'git' })
            end, { desc = 'mini.pick.files' })
        end,
    },
    {
        "nvim-mini/mini.notify",
        event = "User Ready",
        config = function()
            local notify = require("mini.notify")

            notify.setup {
                lsp_progress = {
                    enable = true,
                },
            }

            vim.notify = notify.make_notify()
        end,
    },
    -- {
    --     "nvim-mini/mini.sessions",
    --     version = false,
    --     config = function()
    --         require('mini.sessions').setup()
    --     end,
    --     keys = {
    --         { "<leader>sd", function() require('mini.sessions').delete() end, desc = "Delete Sessions" },
    --         { "<leader>sl", function() require('mini.sessions').select() end, desc = "List Sessions" },
    --         { "<leader>ss", function() require('mini.sessions').write() end, desc = "Save Session" },
    --     },
    --     init = function()
    --         vim.api.nvim_create_autocmd("VimLeave", {
    --             callback = function()
    --                 require('mini.sessions').write(vim.fn.getcwd())
    --             end,
    --         })
    --
    --         vim.api.nvim_create_autocmd("VimEnter", {
    --             callback = function()
    --                 if vim.fn.argc() == 0 then
    --                     require('mini.sessions').read(vim.fn.getcwd())
    --                 end
    --             end,
    --         })
    --     end,
    -- }
}
