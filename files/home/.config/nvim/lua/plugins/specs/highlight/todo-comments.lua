return {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = 'VeryLazy',
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

        vim.keymap.set("n", "]t", function()
            todo_comments.jump_next()
        end, { desc = "Next todo comment" })
        vim.keymap.set("n", "[t", function()
            todo_comments.jump_prev()
        end, { desc = "Previous todo comment" })
        vim.keymap.set("n", "]t", function()
            todo_comments.jump_next({ keywords = { "ERROR", "WARNING" } })
        end, { desc = "Next error/warning todo comment" })
    end
}
