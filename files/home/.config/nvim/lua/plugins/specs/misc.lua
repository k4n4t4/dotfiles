return {
    { "nvim-tree/nvim-web-devicons" },

    --[[ LSP PLUGINS ]]--
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        lazy = false,
    },
    {
        "mason-org/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup {
                ui = {
                    border = 'double',
                },
            }
        end,
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonLog",
            "MasonUpdate",
        },
    },

    --[[ COPILOT ]]--
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = 'InsertEnter',
        opts = {
            filetypes = {
                ["*"] = true,
            },
            suggestion = {
                enabled = false,
                auto_trigger = true,
                keymap = {
                    accept = "<M-l>",
                },
            },
            panel = { enabled = false },
        },
    },


    --[[ EDITOR PLUGINS ]]--

    -- noti
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        event = "VeryLazy",
        config = function()
            require('noice').setup {
                views = {
                    mini = { win_options = { winblend = 10 } },
                    popup = { win_options = { winblend = 10 } },
                    notify = { win_options = { winblend = 10 } },
                },
                cmdline = {
                    enabled = true,
                    view = 'cmdline',
                    format = {
                        cmdline = { pattern = "^:", icon = "", lang = "vim" },
                        search_down = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
                        search_up = { kind = "search", pattern = "^%?", icon = "", lang = "regex" },
                        filter = { pattern = "^:%s*!", icon = "$", lang = "bash" },
                        lua = { pattern = { "^:%s*lua%s+", "^:%s*lua%s*=%s*", "^:%s*=%s*" }, icon = "", lang = "lua" },
                        help = { pattern = "^:%s*he?l?p?%s+", icon = "󰋗" },
                        input = { view = "cmdline_input", icon = "󰥻" },
                    },
                },
                messages = {
                    enabled = true,
                    view = 'mini',
                    view_warn = 'mini',
                    view_error = 'mini',
                    view_history = 'messages',
                    view_search = 'virtualtext',
                },
                lsp = {
                    hover = { enabled = false },
                    signature = { enabled = false },
                },
                throttle = 1000 / 30,
            }
        end,
    },
    -- tabuf
    {
        'akinsho/bufferline.nvim',
        event = "VeryLazy",
        version = "*",
        dependencies = 'nvim-tree/nvim-web-devicons',
        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and " " or " "
                        return " " .. icon .. count
                    end,
                    always_show_bufferline = true,
                },
                highlights = {
                    buffer_selected = {
                        bold = true,
                        italic = false,
                    },
                },
            })

            vim.keymap.set("n", "<A-j>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
            vim.keymap.set("n", "<A-k>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })

            vim.keymap.set("n", "<A-S-j>", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
            vim.keymap.set("n", "<A-S-k>", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })

            vim.keymap.set("n", "<A-x>", "<Cmd>BufferLinePickClose<CR>", { desc = "Pick and close buffer" })

            vim.keymap.set("n", "<A-s>", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })

            vim.keymap.set("n", "<A-C-j>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
            vim.keymap.set("n", "<A-C-k>", "<Cmd>tabprevious<CR>", { desc = "Prev tab" })
        end,
    },
    -- breadcrumbs
    {
        'Bekaboo/dropbar.nvim',
        event = 'VeryLazy',
        config = function()
            local dropbar_api = require('dropbar.api')
            local set = vim.keymap.set
            set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
            set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
            set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
        end
    },
    -- debugging
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { '<F5>',  function() require('dap').continue() end,          desc = 'DAP Continue' },
            { '<F10>', function() require('dap').step_over() end,         desc = 'DAP Step Over' },
            { '<F11>', function() require('dap').step_into() end,         desc = 'DAP Step Into' },
            { '<F12>', function() require('dap').step_out() end,          desc = 'DAP Step Out' },
            { '<F9>',  function() require('dap').toggle_breakpoint() end, desc = 'DAP Toggle Breakpoint' },
        },
        config = function()
            local dap, dapui = require("dap"), require("dapui")

            dapui.setup()

            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

            vim.keymap.set('n', '<F5>', function() dap.continue() end)
            vim.keymap.set('n', '<F10>', function() dap.step_over() end)
            vim.keymap.set('n', '<F11>', function() dap.step_into() end)
            vim.keymap.set('n', '<F12>', function() dap.step_out() end)
            vim.keymap.set('n', '<Leader>b', function() dap.toggle_breakpoint() end)


            -- Load all DAP configurations from the lua/plugins/dap directory
            local path = vim.fn.stdpath("config") .. "/lua/plugins/dap"
            local handle = vim.uv.fs_scandir(path)

            if handle then
                while true do
                    local name, t = vim.uv.fs_scandir_next(handle)
                    if not name then break end
                    local file_type = t or vim.uv.fs_stat(path .. "/" .. name).type
                    if file_type == "file" and name:match("%.lua$") then
                        local lang = name:gsub("%.lua$", "")
                        require("plugins.dap." .. lang)
                    end
                end
            end
        end,
    },
    -- context
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = 'VeryLazy',
        config = function()
            require("treesitter-context").setup { enable = true }
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "WinSeparator" })
        end,
    },
}
