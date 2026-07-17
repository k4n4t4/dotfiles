return {
    { "nvim-tree/nvim-web-devicons" },

    --[[ LSP PLUGINS ]]--
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
    },
    {
        "mason-org/mason.nvim",
        opts = {
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
        event = "VeryLazy",
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            mason_lspconfig.setup { }
        end,
    },

    --[[ COPILOT ]]--
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        opts = {
            filetypes = {
                ['*'] = function()
                    local fname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
                    local disable_patterns = { 'env', 'conf', 'local', 'private' }
                    return vim.iter(disable_patterns):all(function(pattern)
                        return not string.match(fname, pattern)
                    end)
                end,
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


    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            vim.api.nvim_create_autocmd({"RecordingEnter", "RecordingLeave"}, {
                group = vim.api.nvim_create_augroup("LualineMacroRefresh", { clear = true }),
                callback = function() require("lualine").refresh() end,
            })
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
            require("lualine").setup {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    component_separators = { left = '|', right = '|' },
                    section_separators = { left = '', right = '' },


                    globalstatus = true,
                },
                sections = {
                    lualine_a = {
                        "mode",
                        macro_status,
                    },
                    lualine_b = { "branch", "diff", "diagnostics" },
                    lualine_c = {
                        {
                            "filename",
                            path = 1,
                            file_status = true,
                            shorting_target = 40,
                            symbols = {
                                modified = " [+]",
                                readonly = " [RO]",
                                unnamed = "Untitled",
                            },
                        },
                    },
                    lualine_x = { lsp_status, "encoding", "fileformat", "filetype" },
                    lualine_y = { "progress", "searchcount" },
                    lualine_z = { "location" },
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
    -- notify
    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
        event = "VeryLazy",
        config = function()
            require('noice').setup {
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
                    ---@diagnostic disable-next-line: unused-local
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
            transparent.setup { }
        end,
        keys = {
            { mode = "n", "<Leader>T",  function() require('transparent').toggle() end, desc = 'Toggle transparency' },
        },
    },

    -- completion
    {
        "saghen/blink.cmp",
        version = '*',
        dependencies = {
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",

            "giuxtaposition/blink-cmp-copilot",
            'brenoprata10/nvim-highlight-colors',
            "moyiz/blink-emoji.nvim",
            "xzbdmw/colorful-menu.nvim",

            "Kaiser-Yang/blink-cmp-dictionary",
            'Kaiser-Yang/blink-cmp-git',
            'Kaiser-Yang/blink-cmp-avante',

            "epwalsh/obsidian.nvim",
            { "saghen/blink.compat", version = false },
            "hrsh7th/cmp-calc",
        },
        event = { "InsertEnter", "CmdLineEnter" },
        config = require("plugins.config.blink_cmp").config,
    },
}
