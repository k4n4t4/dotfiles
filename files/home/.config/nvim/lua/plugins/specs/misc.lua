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

    -- explorer
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        event = 'User Ready',
        keys = {
            { mode = 'n', "<leader>E", "<CMD>Neotree toggle<CR>", desc = "Neotree Toggle" },
        },
        opts = {
            filesystem = { window = { width = 30 } },
        },
    },
    -- breadcrumbs
    {
        'Bekaboo/dropbar.nvim',
        event = 'User Ready',
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
        event = 'User Ready',
        config = function()
            require("treesitter-context").setup { enable = true }
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "WinSeparator" })
        end,
    },
    -- statusline
    {
        "https://github.com/k4n4t4/statusline.nvim",
        lazy = false,
        config = function()
            vim.opt.cmdheight = 0
            vim.opt.laststatus = 3

            local stl = require "statusline"

            stl.setup {
                statusline = function(ctx)
                    local mode = stl.mode { align = "center" }
                    local lsp = stl.lsp { show = false }
                    local git = stl.git()
                    local diagnostic = stl.diagnostic()
                    local encoding = stl.encoding()
                    local fileformat = stl.fileformat()
                    local macro = stl.macro_recording()
                    local search_count = stl.search_count()
                    local file = stl.file()
                    local flags = stl.flags()
                    local filetype = stl.filetype { icon_provider = "nvim-web-devicons" }

                    local sep = "%#Comment#│%*"

                    if ctx.active then
                        return stl.make_str {
                            {
                                hl = mode.hl,
                                content = mode.content,
                            },
                            " ", sep, " ",
                            macro and {
                                hl = macro.hl,
                                content = macro.content,
                            } or "",
                            " ",
                            file or "",
                            flags and {
                                hl = flags.hl,
                                content = flags.content,
                            } or "",
                            " ",
                            git and {
                                content = git,
                            } or "",
                            " ",
                            diagnostic and {
                                content = diagnostic,
                            } or "",
                            "%=%<",
                            "%S ",
                            search_count or "",
                            lsp and {
                                hl = "Number",
                                click = lsp.click,
                                content = lsp.content,
                            } or "",
                            " ",
                            filetype or "",
                            " ", sep, " ",
                            encoding or "",
                            " ",
                            fileformat and ((fileformat.icon or "") .. (fileformat.label or "")) or "",
                            " ", sep, " ",
                            "%l:%c|%P",
                        }
                    else
                        return stl.make_str {
                            {
                                hl = mode.hl,
                                content = mode.content,
                            },
                            " ",
                            file or "",
                            flags and {
                                hl = flags.hl,
                                content = flags.content,
                            } or "",
                            "%=%<",
                            filetype and {
                                hl = filetype.hl,
                                content = filetype.content,
                            } or "",
                            " ", sep, " ",
                            "%l:%c  %P",
                        }
                    end
                end,
            }
        end,
    },
}
