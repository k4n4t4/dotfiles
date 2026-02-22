return {
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = 'InsertEnter',
        opts = {
            filetypes = {
                ["*"] = true,
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
    {
        "zbirenbaum/copilot-cmp",
        deprecations = {
            "zbirenbaum/copilot.lua",
        },
        cmd = "Copilot",
        event = 'InsertEnter',
        config = true,
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        deprecations = {
            "zbirenbaum/copilot.lua",
            "nvim-lua/plenary.nvim",
        },
        build = "make tiktoken",
        keys = {
            {
                "<leader>cc",
                function()
                    require("CopilotChat").open {
                        sticky = {
                            "#buffer",
                            "#gitdiff:staged",
                            "#selection",
                        },
                    }
                end,
                mode = { "n", "v" },
                desc = "Copilot Chat Open"
            },
            { "<leader>ct", function() require("CopilotChat").toggle() end, mode = { "n", "v" }, desc = "Copilot Chat Toggle" },
            { "<leader>cq", function() require("CopilotChat").close() end,  mode = { "n", "v" }, desc = "Copilot Chat Close" },
            { "<leader>cs", function() require("CopilotChat").stop() end,   mode = { "n", "v" }, desc = "Copilot Chat Stop" },
            { "<leader>cr", function() require("CopilotChat").reset() end,  mode = { "n", "v" }, desc = "Copilot Chat Reset" },
            { "<leader>cS", function() require("CopilotChat").save() end,   mode = { "n", "v" }, desc = "Copilot Chat Save" },
        },
        config = function()
            local language = "japanese"

            local group = vim.api.nvim_create_augroup("CopilotChatNoNumber", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group,
                pattern = "copilot-chat",
                callback = function()
                    vim.schedule(function()
                        vim.opt_local.number = false
                        vim.opt_local.relativenumber = false
                        vim.opt_local.signcolumn = "no"
                    end)
                end,
            })

            require("CopilotChat").setup {
                language = language,
                window = {
                    layout = 'vertical',
                    width = 0.4,
                },
                debug = false,
                question_header = '## User ',
                answer_header = '## Copilot ',
                error_header = '## Error ',
                mappings = {
                    accept_diff = {
                        normal = '<C-y>',
                        insert = '<C-y>',
                    },
                },
                prompts = {
                    Explain = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        },
                        prompt = "/COPILOT_EXPLAIN Please explain the code in " .. language .. ".",
                        mapping = '<leader>ce',
                        description = "Ask for code explanation",
                    },
                    Review = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        },
                        prompt = '/COPILOT_REVIEW Please review the code in ' .. language .. '.',
                        mapping = '<leader>cv',
                        description = "Ask for code review",
                    },
                    Fix = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        },
                        prompt = "/COPILOT_FIX There is a problem with this code. Please show the fixed code and explain in " .. language .. ".",
                        mapping = '<leader>cf',
                        description = "Ask for code fix",
                    },
                    Optimize = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        },
                        prompt = "/COPILOT_REFACTOR Please optimize the selected code for performance and readability, and explain in " .. language .. ".",
                        mapping = '<leader>co',
                        description = "Ask for code optimization",
                    },
                    Docs = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        },
                        prompt = "/COPILOT_GENERATE Please generate documentation comments for the selected code in " .. language .. ".",
                        mapping = '<leader>cg',
                        description = "Ask for code documentation",
                    },
                    Tests = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        },
                        prompt = "/COPILOT_TESTS Please write detailed unit tests for the selected code and explain in " .. language .. ".",
                        mapping = '<leader>cd',
                        description = "Ask for test code",
                    },
                    FixDiagnostic = {
                        sticky = {
                            "#buffer",
                        },
                        prompt = 'Please fix the issues according to the code diagnostics and explain the changes in ' .. language .. '.',
                        mapping = '<leader>cF',
                        description = "Ask for code fix",
                        selection = require('CopilotChat.select').diagnostics,
                    },
                },
            };
        end,
    }
}
