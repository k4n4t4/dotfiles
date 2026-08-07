return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = {
                enabled = true,
                preset = require("plugins.config.snacks.dashboard").preset,
            },
            explorer = {
                enabled = true,
                layout = { auto_hide = { "input" } },
            },
            indent = { enabled = true },
            input = { enabled = true },
            image = {
                enabled = true,
                math = {
                    latex = {
                        font_size = "normalsize",
                    },
                },
                doc = {
                    enabled = true,
                    inline = false,
                    float = true,
                },
            },
            picker = {
                enabled = true,
                ui_select = true,
                hidden = true,
                ignored = false,
                sources = {
                    matcher = { frecency = true, cwd_bonus = true, sort_empty = true },
                    grep = { hidden = true, regex = true },
                    explorer = { layout = require("plugins.config.snacks.picker_layout").explorer_layout },
                },
                layout = require("plugins.config.snacks.picker_layout").layout,
                win = {
                    preview = { wo = { winblend = 0 } },
                },
            },
            notifier = { enabled = false },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = false },
            statuscolumn = {
                enabled = true,
                left = { "mark", "sign" },
                right = { "fold", "git" },
                folds = {
                    open = true,
                    git_hl = true,
                },
            },
            words = { enabled = true },
            scratch = { enabled = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uD")
                end,
            })
        end,
        keys = {
            -- explorer
            { "<leader>e",       function() Snacks.picker.explorer() end,              desc = "explorer" },

            -- scratch
            { "<leader>s",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },

            -- picker
            { "<leader>P",       function() Snacks.picker.pick() end,                  desc = "Picker" },
            { "<leader>f",       function() Snacks.picker.files() end,                 desc = "find files" },
            { "<leader>p",       function() Snacks.picker.projects() end,              desc = "Projects" },
            { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
            { "<leader>/",       function() Snacks.picker.grep() end,                  desc = "grep" },
            { "<leader>r",       function() Snacks.picker.recent() end,                desc = "Recent Files" },
            { "<leader>b",       function() Snacks.picker.buffers() end,               desc = "Buffers" },
            { "<leader>q",       function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
            { "<leader>?",       function() Snacks.picker.help() end,                  desc = "Help Tags" },
            { "<leader>dd",      function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
            { "<leader>ll", require("plugins.config.snacks.lsp_picker").lsp_picker, desc = "Lsp List (current)" },
            { "<leader>lL", require("plugins.config.snacks.lsp_picker").lsp_picker_all, desc = "Lsp List" },
            { "<leader>ls",         function() Snacks.picker.lsp_symbols() end,                            desc = "LSP Symbols" },
            { "<leader>lS",         function() Snacks.picker.lsp_workspace_symbols() end,                  desc = "LSP Workspace Symbols" },
            { "gd",         function() Snacks.picker.lsp_definitions() end,                        nowait = true,                 desc = "Definitions" },
            { "gr",         function() Snacks.picker.lsp_references() end,                         nowait = true,                 desc = "References" },
            { "gi",         function() Snacks.picker.lsp_implementations() end,                    nowait = true,                 desc = "Implementations" },
            { "gt",         function() Snacks.picker.lsp_type_definitions() end,                   nowait = true,                 desc = "Type Definitions" },
            -- words
            { "]]",         function() Snacks.words.jump(vim.v.count1) end,                                   desc = "Next reference" },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end,                                  desc = "Previous reference" },

            -- git
            { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff" },
            { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
            { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },

            -- terminal
            { "<leader>kk", function() Snacks.terminal(nil, { win = { position = "bottom" } }) end, desc = "Toggle Terminal" },
            { "<leader>kf", function() Snacks.terminal(nil, { win = { border = "single", position = "float" } }) end, desc = "Float Terminal" },

            -- toggle
            { "<leader>z",  function() Snacks.zen() end, desc = "Toggle Zen Mode" },
            { "<leader>Z",  function() Snacks.zen.zoom() end, desc = "Toggle Zoom" },
        },
    },
}
