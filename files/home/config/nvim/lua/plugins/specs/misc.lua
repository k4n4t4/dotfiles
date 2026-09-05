return {
    -- TREESITTER
    { -- nvim treesitter
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local ts = require("nvim-treesitter")
            ts.install {
                "bash",
                "bibtex",
                "css",
                "dockerfile",
                "ecma",
                "fish",
                "html",
                "html_tags",
                "java",
                "javadoc",
                "javascript",
                "json",
                "jsx",
                "latex",
                "lua",
                "luadoc",
                "markdown",
                "markdown_inline",
                "scss",
                "svelte",
                "tsx",
                "typescript",
                "typst",
                "vue",
                "yaml",
            }
        end
    },

    -- LSP PLUGINS
    { -- mason
        "mason-org/mason.nvim",
        opts = {
            PATH = "append",
            ui = {
                border = 'single',
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                },
            },
        },
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonLog",
            "MasonUpdate",
        },
    },
    { -- mason-lspconfig
        "mason-org/mason-lspconfig.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        event = "VeryLazy",
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup {}
        end,
    },
    { -- rust
        "mrcjkb/rustaceanvim",
        version = "^9",
        lazy = false,
    },
    { -- lua
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
                { path = "snacks.nvim",        words = { "Snacks" } },
                { path = "lazy.nvim",          words = { "LazyVim" } },
            },
        },
    },
    { -- java
        "mfussenegger/nvim-jdtls",
        ft = "java",
    },


    -- EDITOR PLUGINS
    { -- statusline
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = require("plugins.config.lualine").config,
    },
    { -- tabuf
        'akinsho/bufferline.nvim',
        event = "VeryLazy",
        version = "*",
        config = function()
            require("bufferline").setup({
                options = {
                    diagnostics = "nvim_lsp",
                    ---@diagnostic disable-next-line: unused-local
                    diagnostics_indicator = function(count, level, diagnostics_dict, context)
                        local icon = level:match("error") and " " or "󰀪 "
                        return " " .. icon .. count
                    end,
                    always_show_bufferline = false,
                },
                highlights = {
                    buffer_selected = {
                        bold = true,
                        italic = false,
                    },
                },
            })
        end,
        keys = {
            { "<M-j>",   "<Cmd>BufferLineCycleNext<CR>", desc = "Next buffer" },
            { "<M-k>",   "<Cmd>BufferLineCyclePrev<CR>", desc = "Prev buffer" },
            { "<M-S-j>", "<Cmd>BufferLineMoveNext<CR>",  desc = "Move buffer right" },
            { "<M-S-k>", "<Cmd>BufferLineMovePrev<CR>",  desc = "Move buffer left" },
            { "<M-s>",   "<Cmd>BufferLinePick<CR>",      desc = "Pick buffer" },
            { "<M-]>",   "<Cmd>tabnext<CR>",             desc = "Next tab" },
            { "<M-[>",   "<Cmd>tabprevious<CR>",         desc = "Prev tab" },
            { "<M-n>",   "<Cmd>enew<CR>",                desc = "New buffer" },
            { "<M-S-n>", "<Cmd>tabnew<CR>",              desc = "New tab" },
            { "<M-x>",   "<Cmd>bdelete<CR>",             desc = "Close buffer" },
            { "<M-S-x>", "<Cmd>tabclose<CR>",            desc = "Close tab" },
        }
    },
    { -- notify
        "folke/noice.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
        event = "VeryLazy",
        config = function()
            require("noice").setup {
                cmdline = {
                    view = "cmdline",
                },
                lsp = {
                    hover = { enabled = false },
                    signature = { enabled = false },
                },
                throttle = 1000 / 30,
            }
        end,
    },
    { -- which key
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            local wk = require "which-key"
            wk.setup {
                preset = "helix",
                win = {
                    border = "none",
                },
            }
        end,
        keys = {
            {
                "<leader>?",
                function()
                    local wk = require("which-key")
                    wk.show { global = false }
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    { -- breadcrumbs
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
    { -- debugging
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "nvim-neotest/nvim-nio",
        },
        cmd = {
            "DapContinue",
            "DapDisconnect",
            "DapNew",
            "DapTerminate",
            "DapRestartFrame",
            "DapStepInto",
            "DapStepOut",
            "DapStepOver",
            "DapPause",
            "DapEval",
            "DapToggleRepl",
            "DapClearBreakpoints",
            "DapToggleBreakpoint",
            "DapSetLogLevel",
            "DapShowLog",
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

            vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = 'DiagnosticSignError', linehl = '', numhl = '' })
            vim.fn.sign_define('DapBreakpointCondition', { text = '●', texthl = 'DiagnosticSignWarn', linehl = '', numhl = '' })
            vim.fn.sign_define('DapStopped', { text = '▶', texthl = 'DiagnosticSignOk', linehl = 'CursorLine', numhl = '' })

            dap.listeners.before.attach.dapui_config = function() dapui.open() end
            dap.listeners.before.launch.dapui_config = function() dapui.open() end
            dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
            dap.listeners.before.event_exited.dapui_config = function() dapui.close() end

            -- Load all DAP configurations from the lua/plugins/dap directory
            local path = vim.fn.stdpath("config") .. "/lua/plugins/config/dap"
            local handle = vim.uv.fs_scandir(path)

            if handle then
                while true do
                    local name, t = vim.uv.fs_scandir_next(handle)
                    if not name then break end
                    local file_type = t or vim.uv.fs_stat(path .. "/" .. name).type
                    if file_type == "file" and name:match("%.lua$") then
                        local lang = name:gsub("%.lua$", "")
                        require("plugins.config.dap." .. lang)
                    end
                end
            end
        end,
    },
    { -- context
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = 'VeryLazy',
        config = function()
            require("treesitter-context").setup { enable = true }
            vim.api.nvim_set_hl(0, "TreesitterContext", { link = "WinSeparator" })
        end,
    },
    { -- transparent
        "k4n4t4/transparent.nvim",
        config = function()
            local transparent = require("transparent")
            transparent.setup { groups_extend = {} }
        end,
    },
    { -- todo comments
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        opts = {},
        keys = {
            ---@diagnostic disable-next-line: undefined-field
            { "<Leader>t", function() Snacks.picker.todo_comments() end, desc = "Todo List" },
        },
    },
    { -- dial
        "monaqa/dial.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { mode = 'n', "<C-a>",  function() require("dial.map").manipulate("increment", "normal") end,  desc = "Increment" },
            { mode = 'n', "<C-x>",  function() require("dial.map").manipulate("decrement", "normal") end,  desc = "Decrement" },
            { mode = 'n', "g<C-a>", function() require("dial.map").manipulate("increment", "gnormal") end, desc = "gIncrement" },
            { mode = 'n', "g<C-x>", function() require("dial.map").manipulate("decrement", "gnormal") end, desc = "gDecrement" },
            { mode = 'v', "<C-a>",  function() require("dial.map").manipulate("increment", "visual") end,  desc = "vIncrement" },
            { mode = 'v', "<C-x>",  function() require("dial.map").manipulate("decrement", "visual") end,  desc = "vDecrement" },
            { mode = 'v', "g<C-a>", function() require("dial.map").manipulate("increment", "gvisual") end, desc = "gvIncrement" },
            { mode = 'v', "g<C-x>", function() require("dial.map").manipulate("decrement", "gvisual") end, desc = "gvDecrement" },
        },
        config = function()
            local dial = require "dial.config"
            local augend = require "dial.augend"

            dial.augends:register_group {
                default = {
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.integer.alias.octal,
                    augend.integer.alias.binary,
                    augend.constant.alias.bool,
                },
            }
        end,
    },
    { -- completion
        "saghen/blink.cmp",
        dependencies = {
            "saghen/blink.lib",
            { "saghen/blink.compat", version = false },
            "rafamadriz/friendly-snippets",

            'brenoprata10/nvim-highlight-colors',
            "xzbdmw/colorful-menu.nvim",

            "Kaiser-Yang/blink-cmp-dictionary",
            "Kaiser-Yang/blink-cmp-git",

            "epwalsh/obsidian.nvim",
            "hrsh7th/cmp-calc",
        },
        build = function()
            ---@diagnostic disable-next-line: undefined-field
            require('blink.cmp').build():pwait()
        end,
        event = { "InsertEnter", "CmdLineEnter" },
        config = require("plugins.config.blink_cmp").config,
    },
    { -- code companion
        "olimorris/codecompanion.nvim",
        cmd = {
            "CodeCompanion",
            "CodeCompanionActions",
            "CodeCompanionChat",
            "CodeCompanionCLI",
            "CodeCompanionCmd",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("codecompanion").setup {
                opts = {
                    log_level = "DEBUG",
                    language = "Japanese",
                },
                interactions = {
                    chat = {
                        adapter = {
                            name = "copilot",
                            model = "gpt-4o",
                        },
                    },
                    inline = {
                        adapter = {
                            name = "copilot",
                            model = "gpt-4o",
                        },
                    },
                },
            }
        end,
    },
    { -- obsidian
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
    { -- render markdown
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "Avante" },
        config = function()
            require('render-markdown').setup {
                completions = { lsp = { enabled = true } },
                latex = { enabled = false },
                file_types = { "markdown", "Avante" },
            }
        end,
    },
    { -- markdown preview
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install && git restore .",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },
}
