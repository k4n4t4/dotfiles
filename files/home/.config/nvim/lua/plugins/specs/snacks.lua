return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = true },
            explorer = {
                enabled = true,
                layout = { auto_hide = { "input" } },
            },
            indent = { enabled = true },
            input = { enabled = true },
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
                            preset = "sidebar",
                            backdrop = false,
                            auto_hide = { "input" },
                            config = function(layout)
                                local input = layout.layout[1]
                                local list = layout.layout[2]
                                local preview = layout.layout[3]

                                input.border = "none"
                                list.border = "none"
                                preview.border = { "", " ", "", "", "", "", "", "" }
                            end,
                        },
                    },
                },
                layout = {
                    cycle = false,
                    preset = function()
                        return vim.o.columns >= 120 and "default" or "vertical"
                    end,
                    layout = { backdrop = false },
                    config = function(layout)
                        if vim.o.columns >= 120 then
                            local main_box = layout.layout
                            local input_and_list = layout.layout[1]
                            local input = layout.layout[1][1]
                            local list = layout.layout[1][2]
                            local preview = layout.layout[2]

                            main_box.border = "none"
                            input_and_list.border = { "┌", "─", "─", "│", "─", "─", "└", "│" }
                            input_and_list.width = 0.4
                            input.border = "none"
                            list.border = "none"
                            preview.border = { "", "─", "┐", "│", "┘", "─", "", "" }
                            preview.width = 1 - input_and_list.width
                        else
                            local main_box = layout.layout
                            local input = layout.layout[1]
                            local list = layout.layout[2]
                            local preview = layout.layout[3]

                            main_box.border = "single"
                            input.border = "none"
                            list.border = "none"
                            preview.border = { "", "─", "", "", "", "", "", "" }
                        end
                    end,
                },
                win = {
                    input = { wo = { winblend = 30 } },
                    list = { wo = { winblend = 30 } },
                    preview = { wo = { winblend = 30 } },
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
                folds = { open = true },
            },
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
            { "[[",              function() Snacks.words.jump(-1) end,                 desc = "Previous reference" },
            -- terminal
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
