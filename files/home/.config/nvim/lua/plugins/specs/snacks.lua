return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = {
                enabled = true,
                layout = { auto_hide = { "input" } },
            },
            indent = { enabled = true },
            input = { enabled = true },
            animation = { enabled = true },
            picker = {
                enabled = true,
                ui_select = true,
                hidden = true,
                ignored = false,
                sources = {
                    matcher = { frecency = true, cwd_bonus = true, sort_empty = true },
                    grep = { hidden = true, regex = true },
                    explorer = {
                        layout = {
                            auto_hide = { "input" },
                            layout = {
                                width = 40,
                                min_width = 40,
                                height = 0,
                                position = "left",
                                border = "none",
                                box = "vertical",
                                { win = "input", height = 1, border = "none" },
                                { win = "list", border = "none" },
                                { win = "preview", title = "{preview}", height = 0.4, border = "none" },
                            },
                        },
                    },
                },
                layout = {
                    cycle = true,
                    preset = function()
                        return vim.o.columns >= 100 and "default" or "vertical"
                    end,
                },
            },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            words = { enabled = true },
            terminal = { enabled = true },
        },
        keys = {
            -- explorer
            { "<Leader>e",       function() Snacks.picker.explorer() end,              desc = "explorer" },
            -- picker
            { "<Leader>P",       function() Snacks.picker.pick() end,                  desc = "Picker" },
            { "<Leader>f",       function() Snacks.picker.files() end,                 desc = "find files" },
            { "<leader>p",       function() Snacks.picker.projects() end,              desc = "Projects" },
            { "<leader><space>", function() Snacks.picker.smart() end,                 desc = "Smart Find Files" },
            { "<Leader>/",       function() Snacks.picker.grep() end,                  desc = "grep" },
            { "<Leader>r",       function() Snacks.picker.recent() end,                desc = "Recent Files" },
            { "<Leader>b",       function() Snacks.picker.buffers() end,               desc = "Buffers" },
            { "<Leader>d",       function() Snacks.picker.diagnostics() end,           desc = "Diagnostics" },
            { "<Leader>q",       function() Snacks.picker.qflist() end,                desc = "Quickfix List" },
            { "<Leader>?",       function() Snacks.picker.help() end,                  desc = "Help Tags" },
            { "<Leader>s",       function() Snacks.picker.lsp_symbols() end,           desc = "LSP Symbols" },
            { "<Leader>S",       function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },
            { "gd",              function() Snacks.picker.lsp_definitions() end,       nowait = true,                 desc = "Definitions" },
            { "gr",              function() Snacks.picker.lsp_references() end,        nowait = true,                 desc = "References" },
            { "gi",              function() Snacks.picker.lsp_implementations() end,   nowait = true,                 desc = "Implementations" },
            { "gt",              function() Snacks.picker.lsp_type_definitions() end,  nowait = true,                 desc = "Type Definitions" },
            --words
            { "]]",              function() Snacks.words.jump(1) end,                  desc = "Next reference" },
            { "[[",              function() Snacks.words.jump(-1) end,                 desc = "Next reference" },
            -- temrinal
            { "<leader>kk",      function() Snacks.terminal() end,                     desc = "Toggle Terminal" },
            {
                "<leader>kf",
                function()
                    Snacks.terminal(nil,
                    { win = { position = "float", wo = { winblend = 30, }, } })
                end,
                desc = "Float Terminal"
            },
        },
    },
}
