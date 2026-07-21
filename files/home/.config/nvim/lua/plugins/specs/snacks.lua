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
            image = { enabled = true },
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
        },
        init = function()
        end,
        keys = {
            -- explorer
            { "<Leader>e",       function() Snacks.picker.explorer() end,              desc = "explorer" },
            -- scratch
            { "<leader>s",       function() Snacks.scratch() end,                      desc = "Toggle Scratch Buffer" },
            { "<leader>S",       function() Snacks.scratch.select() end,               desc = "Select Scratch Buffer" },
            -- picker
            { "<Leader>P",       function() Snacks.picker.pick() end,                  desc = "Picker" },
            { "<Leader>f",       function() Snacks.picker.files() end,                 desc = "find files" },
            { "<Leader>p",       function() Snacks.picker.projects() end,              desc = "Projects" },
            { "<Leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
            { "<Leader>/",       function() Snacks.picker.grep() end,                  desc = "grep" },
            { "<Leader>r",       function() Snacks.picker.recent() end,                desc = "Recent Files" },
            { "<Leader>b",       function() Snacks.picker.buffers() end,               desc = "Buffers" },
            { "<Leader>d",       function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
            { "<Leader>q",       function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
            { "<Leader>?",       function() Snacks.picker.help() end,                  desc = "Help Tags" },
            { "<Leader>ll", require("plugins.config.snacks.lsp_picker").lsp_picker, desc = "Lsp List (current)" },
            { "<Leader>lL", require("plugins.config.snacks.lsp_picker").lsp_picker_all, desc = "Lsp List" },
            { "<leader>ls",         function() Snacks.picker.lsp_symbols() end,                            desc = "LSP Symbols" },
            { "<leader>lS",         function() Snacks.picker.lsp_workspace_symbols() end,                  desc = "LSP Workspace Symbols" },
            { "gd",         function() Snacks.picker.lsp_definitions() end,                        nowait = true,                 desc = "Definitions" },
            { "gr",         function() Snacks.picker.lsp_references() end,                         nowait = true,                 desc = "References" },
            { "gi",         function() Snacks.picker.lsp_implementations() end,                    nowait = true,                 desc = "Implementations" },
            { "gt",         function() Snacks.picker.lsp_type_definitions() end,                   nowait = true,                 desc = "Type Definitions" },
            --words
            { "]]",         function() Snacks.words.jump(vim.v.count1) end,                                   desc = "Next reference" },
            { "[[",         function() Snacks.words.jump(-vim.v.count1) end,                                  desc = "Previous reference" },
            -- terminal
            { "<Leader>kk", function() Snacks.terminal(nil, { win = { position = "bottom" } }) end, desc = "Toggle Terminal" },
            { "<Leader>kf", function() Snacks.terminal(nil, { win = { border = "single", position = "float" } }) end, desc = "Float Terminal" },
        },
    },
}
