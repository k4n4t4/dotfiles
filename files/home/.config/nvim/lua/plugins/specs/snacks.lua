return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            dashboard = { enabled = false },
            explorer = { enabled = true },
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
                },
            },
            notifier = {
                enabled = true,
                timeout = 3000,
                width = { min = 40, max = 0.4 },
                height = { min = 1, max = 0.6 },
                style = "fancy",
                top_down = true,
            },
            quickfile = { enabled = true },
            scope = { enabled = true },
            scroll = { enabled = true },
            words = { enabled = true },
            terminal = { enabled = true },
        },
        init = function()
            vim.api.nvim_create_autocmd("LspProgress", {
                ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
                callback = function(ev)
                    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                    vim.notify(vim.lsp.status(), "info", {
                        id = "lsp_progress",
                        title = "LSP Progress",
                        opts = function(notif)
                            notif.icon = ev.data.params.value.kind == "end" and " "
                                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                        end,
                    })
                end,
            })
        end,
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
