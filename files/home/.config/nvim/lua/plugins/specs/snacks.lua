return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = false },
            indent = { enabled = true },
            input = { enabled = true },
            picker = {
                enabled = true,
                ui_select = true,
                hidden = true,
                ignored = false,
                sources = {
                    files = {
                        cmd = "fd",
                        args = {
                            "--hidden",
                            "--exclude",
                            ".git",
                            "--exclude",
                            "node_modules",
                            "--exclude",
                            "target",
                            "--exclude",
                            ".mooncakes",
                        },
                        win = {
                            input = {
                                keys = {
                                    ["<CR>"] = { "edit_tab", mode = { "n", "i" } },
                                },
                            },
                        },
                    },
                    grep = {
                        hidden = true,
                        cmd = "rg",
                        regex = true,
                        win = {
                            input = {
                                keys = {
                                    ["<CR>"] = { "edit_tab", mode = { "n", "i" } },
                                },
                            },
                        },
                    },
                },
            },
            notifier = { enabled = true },
            quickfile = { enabled = false },
            scope = { enabled = true },
            scroll = { enabled = true },
            statuscolumn = { enabled = false },
            words = { enabled = true },
            terminal = {
                enabled = true,
            },
        },
        keys = {
            -- explorer
            {
                "<Leader>e",
                function() Snacks.picker.explorer() end,
                desc = "explorer",
            },
            -- picker
            {
                "<Leader>p",
                function() Snacks.picker.pick() end,
                desc = "Picker",
            },
            {
                "<Leader>f",
                function() Snacks.picker.files() end,
                desc = "find files",
            },
            {
                "<Leader>/",
                function() Snacks.picker.grep() end,
                desc = "grep",
            },
            {
                "<Leader>r",
                function() Snacks.picker.recent() end,
                desc = "Recent Files",
            },
            {
                "<Leader>b",
                function() Snacks.picker.buffers() end,
                desc = "Buffers",
            },
            {
                "<Leader>d",
                function() Snacks.picker.diagnostics() end,
                desc = "Diagnostics",
            },
            {
                "<Leader>q",
                function() Snacks.picker.qflist() end,
                desc = "Quickfix List",
            },
            {
                "<Leader>?",
                function() Snacks.picker.help() end,
                desc = "Help Tags",
            },
            {
                "<Leader>s",
                function() Snacks.picker.lsp_symbols() end,
                desc = "LSP Symbols",
            },
            {
                "<Leader>S",
                function() Snacks.picker.lsp_workspace_symbols() end,
                desc = "LSP Workspace Symbols",
            },
            {
                "gd",
                function() Snacks.picker.lsp_definitions() end,
                nowait = true,
                desc = "Definitions",
            },
            {
                "gi",
                function() Snacks.picker.lsp_implementations() end,
                nowait = true,
                desc = "Implementations",
            },
            {
                "gt",
                function() Snacks.picker.lsp_type_definitions() end,
                nowait = true,
                desc = "Implementations",
            },
            {
                "gr",
                function() Snacks.picker.lsp_references() end,
                nowait = true,
                desc = "References",
            },
        },
    },
}
