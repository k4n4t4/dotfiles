return {
    -- TREESITTER
    {
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
    {
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
    {
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
    {
        "mrcjkb/rustaceanvim",
        version = "^9",
        lazy = false,
    },
    {
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


    -- EDITOR PLUGINS

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        init = function()
            vim.opt.cmdheight = 0
            vim.opt.laststatus = 0
            vim.opt.showcmd = true
            vim.opt.showcmdloc = "last"
        end,
        config = function()
            vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
                group = vim.api.nvim_create_augroup("LualineMacroRefresh", { clear = true }),
                callback = function() require("lualine").refresh() end,
            })
            local function is_visual_mode()
                local mode = vim.fn.mode()
                return mode == 'v' or mode == 'V' or mode == '\22'
            end
            local function macro_status()
                local reg = vim.fn.reg_recording()
                if reg ~= "" then
                    return "rec @" .. reg
                end
                return ""
            end
            local function lsp_status()
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                if #clients == 0 then
                    return ""
                end
                local names = {}
                for _, client in ipairs(clients) do
                    table.insert(names, client.name)
                end
                return " " .. table.concat(names, ", ")
            end
            local function visual_info()
                local mode = vim.fn.mode()

                local l1, l2 = vim.fn.line('v'), vim.fn.line('.')
                local lines = math.abs(l2 - l1) + 1

                if mode == 'V' then
                    return string.format('%d lines', lines)
                elseif mode == '\22' then
                    local c1, c2 = vim.fn.virtcol('v'), vim.fn.virtcol('.')
                    local cols = math.abs(c2 - c1) + 1
                    return string.format('%dx%d', lines, cols)
                elseif mode == 'v' then
                    local wc = vim.fn.wordcount()
                    local chars = wc.visual_chars or 0
                    if lines > 1 then
                        return string.format('%d lines %d chars', lines, chars)
                    else
                        return string.format('%d chars', chars)
                    end
                else
                    return ''
                end
            end

            require("lualine").setup {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },
                    globalstatus = true,
                    disabled_filetypes = { "dashboard", "snacks_dashboard" },
                },
                sections = {
                    lualine_a = {
                        "mode",
                        macro_status,
                    },
                    lualine_b = {
                        "branch",
                        {
                            "diff",
                            symbols = {
                                added    = " ",
                                modified = " ",
                                removed  = " ",
                            },
                        },
                        {
                            "diagnostics",
                            symbols = {
                                error = '󰅚 ',
                                warn =  '󰀪 ',
                                info =  '󰋽 ',
                                hint =  '󰌶 ',
                            },
                        },
                    },
                    lualine_c = {
                        {
                            "filetype",
                            icon_only = true,
                            separator = "",
                            padding = { left = 1, right = 0 },
                        },
                        {
                            "filename",
                            path = 0,
                            file_status = true,
                            shorting_target = 40,
                            padding = { left = 0 },
                            symbols = {
                                modified = "󰏫",
                                readonly = "󰌾",
                                unnamed  = "󰈔",
                                newfile  = "󰈔",
                            },
                        },
                    },
                    lualine_x = {
                        {
                            function()
                                ---@diagnostic disable-next-line: undefined-field
                                return require("noice").api.status.command.get()
                            end,
                            cond = function()
                                return not is_visual_mode() and
                                package.loaded["noice"] and
                                ---@diagnostic disable-next-line: undefined-field
                                require("noice").api.status.command.has()
                            end,
                        },
                        {
                            visual_info,
                            cond = is_visual_mode,
                        },
                        {
                            "searchcount",
                        },
                    },
                    lualine_y = {
                        lsp_status,
                        {
                            "encoding",
                            separator = "",
                            padding = { left = 1, right = 1 },
                        },
                        {
                            "fileformat",
                            padding = { left = 0, right = 1 },
                        },
                    },
                    lualine_z = {
                        "progress",
                        "location",
                    },
                },
                inactive_sections = {
                    lualine_a = {},
                    lualine_b = {},
                    lualine_c = { "filename" },
                    lualine_x = { "location" },
                    lualine_y = {},
                    lualine_z = {},
                },
                tabline = {},
                extensions = {},
            }
        end,
    },

    -- tabuf
    {
        'akinsho/bufferline.nvim',
        event = "VeryLazy",
        version = "*",
        init = function()
            vim.opt.showtabline = 0
        end,
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

            vim.keymap.set("n", "<M-j>", "<Cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
            vim.keymap.set("n", "<M-k>", "<Cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
            vim.keymap.set("n", "<M-S-j>", "<Cmd>BufferLineMoveNext<CR>", { desc = "Move buffer right" })
            vim.keymap.set("n", "<M-S-k>", "<Cmd>BufferLineMovePrev<CR>", { desc = "Move buffer left" })
            vim.keymap.set("n", "<M-s>", "<Cmd>BufferLinePick<CR>", { desc = "Pick buffer" })
            vim.keymap.set("n", "<M-]>", "<Cmd>tabnext<CR>", { desc = "Next tab" })
            vim.keymap.set("n", "<M-[>", "<Cmd>tabprevious<CR>", { desc = "Prev tab" })
            vim.keymap.set("n", "<M-n>", "<Cmd>enew<CR>", { desc = "New buffer" })
            vim.keymap.set("n", "<M-S-n>", "<Cmd>tabnew<CR>", { desc = "New tab" })
            vim.keymap.set("n", "<M-x>", "<Cmd>bdelete<CR>", { desc = "Close buffer" })
            vim.keymap.set("n", "<M-S-x>", "<Cmd>tabclose<CR>", { desc = "Close tab" })
        end,
    },

    -- notify
    {
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
        keys = {
            ---@diagnostic disable-next-line: undefined-field
            { "<Leader>n", function() Snacks.picker.noice() end, desc = "Noice" },
        },
    },

    -- which key
    {
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

    -- transparent
    {
        "k4n4t4/transparent.nvim",
        config = function()
            local transparent = require("transparent")
            transparent.setup { groups_extend = {} }
        end,
    },

    -- todo comments
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = "VeryLazy",
        opts = {},
        keys = {
            ---@diagnostic disable-next-line: undefined-field
            { "<Leader>t", function() Snacks.picker.todo_comments() end, desc = "Todo List" },
        },
    },

    -- dial
    {
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

    -- completion
    {
        "saghen/blink.cmp",
        version = '*',
        dependencies = {
            { "saghen/blink.compat", version = false },
            "saghen/blink.lib",
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

    -- code companion
    {
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

    -- obsidian
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

    -- markdown
    {
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
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        build = "cd app && npm install && git restore .",
        init = function()
            vim.g.mkdp_filetypes = { "markdown" }
        end,
        ft = { "markdown" },
    },

    -- COLOR SCHEMES
    {
        "folke/tokyonight.nvim",
        enabled = true,
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "tokyonight"
        end,
    },
    {
        "nvim-mini/mini.base16",
        enabled = false,
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
