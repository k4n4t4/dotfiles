return {
    { "nvim-tree/nvim-web-devicons" },

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

    {
        'Bekaboo/dropbar.nvim',
        dependencies = {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        },
        event = 'User Ready',
        config = function()
            local dropbar_api = require('dropbar.api')
            vim.keymap.set('n', '<Leader>;', dropbar_api.pick, { desc = 'Pick symbols in winbar' })
            vim.keymap.set('n', '[;', dropbar_api.goto_context_start, { desc = 'Go to start of current context' })
            vim.keymap.set('n', '];', dropbar_api.select_next_context, { desc = 'Select next context' })
        end
    },

    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreview", "MarkdownPreviewToggle", "MarkdownPreviewStop" },
        build = "cd app && npm install",
        ft = { "markdown" },
    },

    {
        "epwalsh/obsidian.nvim",
        version = "*",
        event = "VeryLazy",
        dependencies = { "nvim-lua/plenary.nvim", },
        config = function()
            local function setup_obsidian()
                local cwd = vim.fn.getcwd()
                local vault = vim.fn.isdirectory(cwd .. "/.obsidian") == 1 and cwd or nil
                if vault then
                    require("obsidian").setup {
                        workspaces = {
                            {
                                name = "main",
                                path = vault,
                            },
                        },
                        preferred_link_style = "wiki",
                        ui = { enable = false, },
                        completion = {
                            blink = true,
                            min_chars = 2,
                        },
                    }
                end
            end

            setup_obsidian()

            vim.api.nvim_create_autocmd("DirChanged", {
                pattern = "*",
                callback = setup_obsidian,
            })
        end,
    },

    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        keys = {
            { '<F5>',      function() require('dap').continue() end,         desc = 'DAP Continue' },
            { '<F10>',     function() require('dap').step_over() end,        desc = 'DAP Step Over' },
            { '<F11>',     function() require('dap').step_into() end,        desc = 'DAP Step Into' },
            { '<F12>',     function() require('dap').step_out() end,         desc = 'DAP Step Out' },
            { '<Leader>b', function() require('dap').toggle_breakpoint() end, desc = 'DAP Toggle Breakpoint' },
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

            local fs = require "utils.fs"
            fs.scandir_dot("plugins.dap", function(fname, name, t)
                local ex = fs.get_extension(fname)
                if t == "file" and ex == "lua" then
                    local lang = fs.get_basename(name)
                    require("plugins.dap." .. lang)
                end
            end)
        end,
    },
}
