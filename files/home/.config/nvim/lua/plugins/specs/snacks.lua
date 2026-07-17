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
            image = { enabled = true },
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
            scratch = { enabled = true },
        },
        keys = {
            -- explorer
            { "<Leader>e",       function() Snacks.picker.explorer() end,              desc = "explorer" },
            -- session
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
            { "<Leader>L",       function()
                local mason_registry = require("mason-registry")
                local mason_lspconfig = require("mason-lspconfig")

                if not mason_registry then return end
                if not mason_lspconfig then return end

                require("snacks").picker.pick {
                    finder = function()
                        local items = {}

                        for _, package in ipairs(mason_registry.get_installed_packages()) do
                            local item = {
                                text = package.name,
                                file = package:get_install_path(),
                            }
                            table.insert(items, item)
                        end

                        return items
                    end,
                    format = "text",
                    preview = "file",
                    confirm = function(picker, item)
                        picker:close()
                        if item then
                            local package = mason_registry.get_package(item.text)
                            local mlsp_mappings = mason_lspconfig.get_mappings()
                            local name = mlsp_mappings.package_to_lspconfig[package.name]
                            if not name then
                                vim.notify("No LSP mapping found for package: " .. package.name, vim.log.levels.WARN, { title = "Mason" })
                                return
                            end
                            vim.notify("Enabling LSP: " .. name, vim.log.levels.INFO, { title = "Mason" })
                            vim.lsp.enable(name)
                        end
                    end,
                }
            end, desc = "LSP list" },
            { "<leader>ls",         function() Snacks.picker.lsp_symbols() end,                            desc = "LSP Symbols" },
            { "<leader>lS",         function() Snacks.picker.lsp_workspace_symbols() end,                  desc = "LSP Workspace Symbols" },
            { "gd",         function() Snacks.picker.lsp_definitions() end,                        nowait = true,                 desc = "Definitions" },
            { "gr",         function() Snacks.picker.lsp_references() end,                         nowait = true,                 desc = "References" },
            { "gi",         function() Snacks.picker.lsp_implementations() end,                    nowait = true,                 desc = "Implementations" },
            { "gt",         function() Snacks.picker.lsp_type_definitions() end,                   nowait = true,                 desc = "Type Definitions" },
            --words
            { "]]",         function() Snacks.words.jump(1) end,                                   desc = "Next reference" },
            { "[[",         function() Snacks.words.jump(-1) end,                                  desc = "Previous reference" },
            -- terminal
            { "<Leader>kk", function() Snacks.terminal() end,                                      desc = "Toggle Terminal" },
            { "<Leader>kf", function() Snacks.terminal(nil, { win = { position = "float" } }) end, desc = "Float Terminal" },
        },
    },
}
