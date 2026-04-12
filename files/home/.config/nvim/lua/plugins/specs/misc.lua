return {
    { "nvim-tree/nvim-web-devicons" },

    { "m-demare/hlargs.nvim", event = 'User Ready' },

    { "norcalli/nvim-colorizer.lua", event = 'User Ready' },

    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {
                check_ts = true,
                ts_config = { },
            }
        end,
    },

    {
        "folke/flash.nvim",
        keys = {
            { mode = "n",               "f" },
            { mode = "n",               "F" },
            { mode = "n",               "t" },
            { mode = "n",               "T" },
            { mode = { "n", "x", "o" }, "<Leader>ff", function() require("flash").jump() end,              desc = "Flash" },
            { mode = { "n", "x", "o" }, "<Leader>ft", function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
            { mode = "o",               "<Leader>fr", function() require("flash").remote() end,            desc = "Remote Flash" },
            { mode = { "o", "x" },      "<Leader>fR", function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
            { mode = { "c" },           "<C-s>",      function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
        },
        opts = {},
    },

    {
        "shellRaining/hlchunk.nvim",
        event = 'User Ready',
        config = function()
            require("hlchunk").setup {
                chunk = {
                    enable = true,
                    style = {
                        { fg = "#303030" },
                        { fg = "#903020" },
                    },
                    use_treesitter = true,
                    chars = {
                        horizontal_line = "─",
                        vertical_line = "│",
                        left_top = "┌",
                        left_bottom = "└",
                        right_arrow = ">",
                    },
                    textobject = "",
                    max_file_size = 1024 * 1024,
                    error_sign = true,
                    delay = 0,
                },
                indent = {
                    enable = false,
                },
            }
        end,
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
                    augend.integer.alias.decimal,
                    augend.integer.alias.decimal_int,
                    augend.integer.alias.hex,
                    augend.integer.alias.octal,
                    augend.integer.alias.binary,
                    augend.date.alias["%Y/%m/%d"],
                    augend.date.alias["%m/%d/%Y"],
                    augend.date.alias["%d/%m/%Y"],
                    augend.date.alias["%m/%d/%y"],
                    augend.date.alias["%d/%m/%y"],
                    augend.date.alias["%m/%d"],
                    augend.date.alias["%-m/%-d"],
                    augend.date.alias["%Y-%m-%d"],
                    augend.date.alias["%Y年%-m月%-d日"],
                    augend.date.alias["%Y年%-m月%-d日(%ja)"],
                    augend.date.alias["%H:%M:%S"],
                    augend.date.alias["%H:%M"],
                    augend.constant.alias.ja_weekday,
                    augend.constant.alias.ja_weekday_full,
                    augend.constant.alias.bool,
                    augend.constant.alias.alpha,
                    augend.constant.alias.Alpha,
                    augend.semver.alias.semver,
                    -- augend.paren.alias.quote;
                    -- augend.paren.alias.brackets;
                    augend.paren.alias.lua_str_literal,
                    augend.paren.alias.rust_str_literal,
                    augend.misc.alias.markdown_header,
                },
            }
        end,
    },

    {
        "Shatur/neovim-session-manager",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        keys = {
            { "<leader>sd", "<cmd>SessionManager delete_session<cr>",       desc = "Delete Sessions" },
            { "<leader>sl", "<cmd>SessionManager load_session<cr>",         desc = "List Sessions" },
            { "<leader>ss", "<cmd>SessionManager save_current_session<cr>", desc = "Save Session" },
        },
        config = function()
            local config = require('session_manager.config')
            require('session_manager').setup({
                autosave_last_session = true,
                autoload_mode = config.AutoloadMode.CurrentDir,
            })
        end,
    },

    {
        "kylechui/nvim-surround",
        version = "^3.0.0",
        event = "User Ready",
        opts = {
            keymaps = {
                normal      = "ys",
                normal_cur  = "yss",
                normal_line = "yS",
                visual      = "S",
                visual_line = "S",
                delete      = "ds",
                change      = "cs",
            },
        },
    },

    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        event = 'User Ready',
        config = function()
            local todo_comments = require("todo-comments")
            todo_comments.setup {
                signs = true,
                sign_priority = 8,
                keywords = {
                    -- FIXME:
                    -- TODO:
                    -- HACK:
                    -- WARN:
                    -- PERF:
                    -- NOTE:
                    -- TEST:
                    FIX = {
                        icon = " ",
                        color = "error",
                        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
                    },
                    TODO = { icon = " ", color = "info" },
                    HACK = { icon = " ", color = "warning", alt = { "REVIEW" } },
                    WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
                    PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
                    NOTE = { icon = " ", color = "hint", alt = { "INFO", "IDEA" } },
                    TEST = { icon = "⏲ ", color = "test", alt = { "DEBUG", "TEMP", "TESTING", "PASSED", "FAILED" } },
                },
                gui_style = {
                    fg = "NONE",
                    bg = "BOLD",
                },
                merge_keywords = true,
                highlight = {
                    multiline = true,
                    multiline_pattern = "^.",
                    multiline_context = 10,
                    before = "",
                    keyword = "wide",
                    after = "fg",
                    pattern = [[.*<(KEYWORDS)\s*:]],
                    comments_only = true,
                    max_line_len = 400,
                    exclude = {},
                },
                colors = {
                    error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
                    warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
                    info = { "DiagnosticInfo", "#2563EB" },
                    hint = { "DiagnosticHint", "#10B981" },
                    default = { "Identifier", "#7C3AED" },
                    test = { "Identifier", "#FF00FF" }
                },
                search = {
                    command = "rg",
                    args = {
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                    },
                    pattern = [[\b(KEYWORDS):]],
                },
            }
        end,
    },

    {
        "folke/trouble.nvim",
        cmd = "Trouble",
        keys = {
            {
                "<LEADER>xx",
                "<CMD>Trouble diagnostics toggle<cr>",
                desc = "Diagnostics (Trouble)",
            },
            {
                "<LEADER>xX",
                "<CMD>Trouble diagnostics toggle filter.buf=0<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<LEADER>xs",
                "<CMD>Trouble symbols toggle focus=false<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<LEADER>xl",
                "<CMD>Trouble lsp toggle focus=false win.position=right<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<LEADER>xL",
                "<CMD>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<LEADER>xQ",
                "<CMD>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
        opts = {},
    },

    {
        "folke/which-key.nvim",
        event = "User Ready",
        keys = {
            {
                mode = "n",
                '<LEADER>?',
                function()
                    require("which-key").show({ global = true })
                end,
                desc = "Which Key"
            },
        },
        config = function()
            local which_key = require "which-key"
            which_key.setup {
                preset = 'modern',
                delay = 1000,
                win = {
                    border = 'single',
                },
            };

            which_key.add {
                { "cs*", group = "+surround change" },
                { "ds*", group = "+surround delete" },
                { "ys*", group = "+surround add" },
                { "S",   group = "+surround visual", mode = "v" },
            }
        end,
    },
}
