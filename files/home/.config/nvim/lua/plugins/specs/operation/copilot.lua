return {
    {
        "zbirenbaum/copilot.lua";
        cmd = "Copilot";
        event = 'VeryLazy';
        opts = {
            filetypes = {
                ["*"] = true;
            };
            suggestion = {
                enabled = false;
                auto_trigger = true;
                keymap = {
                    accept = "<M-l>";
                };
            };
            panel = { enabled = false };
        };
    },
    {
        "zbirenbaum/copilot-cmp",
        deprecations = {
            "zbirenbaum/copilot.lua";
        };
        cmd = "Copilot";
        event = 'VeryLazy';
        config = true;
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim";
        deprecations = {
            "zbirenbaum/copilot.lua";
            "nvim-lua/plenary.nvim";
        };
        build = "make tiktoken";
        event = 'VeryLazy';
        config = function()
            local language = "japanese"

            local group = vim.api.nvim_create_augroup("CopilotChatNoNumber", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = group;
                pattern = "copilot-chat";
                callback = function()
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false
                    vim.opt_local.signcolumn = "no"
                end;
            })

            require("CopilotChat").setup {
                language = language;
                window = {
                    layout = 'vertical';
                    width = 0.4;
                };
                debug = false;
                question_header = '## User ';
                answer_header = '## Copilot ';
                error_header = '## Error ';
                mappings = {
                    accept_diff = {
                        normal = '<C-y>';
                        insert = '<C-y>';
                    };
                };
                prompts = {
                    Explain = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        };
                        prompt = "/COPILOT_EXPLAIN Please explain the code in " .. language .. ".";
                        mapping = '<leader>ce';
                        description = "Ask for code explanation";
                    };
                    Review = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        };
                        prompt = '/COPILOT_REVIEW Please review the code in ' .. language .. '.';
                        mapping = '<leader>cv';
                        description = "Ask for code review";
                    };
                    Fix = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        };
                        prompt = "/COPILOT_FIX There is a problem with this code. Please show the fixed code and explain in " .. language .. ".";
                        mapping = '<leader>cf';
                        description = "Ask for code fix";
                    };
                    Optimize = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        };
                        prompt = "/COPILOT_REFACTOR Please optimize the selected code for performance and readability, and explain in " .. language .. ".";
                        mapping = '<leader>co';
                        description = "Ask for code optimization";
                    };
                    Docs = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        };
                        prompt = "/COPILOT_GENERATE Please generate documentation comments for the selected code in " .. language .. ".";
                        mapping = '<leader>cg';
                        description = "Ask for code documentation";
                    };
                    Tests = {
                        sticky = {
                            "#buffer",
                            "#selection",
                        };
                        prompt = "/COPILOT_TESTS Please write detailed unit tests for the selected code and explain in " .. language .. ".";
                        mapping = '<leader>cd';
                        description = "Ask for test code";
                    };
                    FixDiagnostic = {
                        sticky = {
                            "#buffer",
                        };
                        prompt = 'Please fix the issues according to the code diagnostics and explain the changes in ' .. language .. '.';
                        mapping = '<leader>cF';
                        description = "Ask for code fix";
                        selection = require('CopilotChat.select').diagnostics;
                    };
                };
            };

            local map = vim.keymap.set

            map({'n', 'v'}, '<leader>cc',
                function()
                    require("CopilotChat").open {
                        sticky = {
                            "#buffer",
                            "#gitdiff:staged",
                            "#selection",
                        };
                    }
                end,
            { desc = 'Copilot Chat Open' })
            map({'n', 'v'}, '<leader>ct',
                function()
                    require("CopilotChat").toggle()
                end,
            { desc = 'Copilot Chat Toggle' })
            map({'n', 'v'}, '<leader>cq',
                function()
                    require("CopilotChat").close()
                end,
            { desc = 'Copilot Chat Close' })
            map({'n', 'v'}, '<leader>cs',
                function()
                    require("CopilotChat").stop()
                end,
            { desc = 'Copilot Chat Stop' })
            map({'n', 'v'}, '<leader>cr',
                function()
                    require("CopilotChat").reset()
                end,
            { desc = 'Copilot Chat Reset' })
            map({'n', 'v'}, '<leader>cS',
                function()
                    require("CopilotChat").save()
                end,
            { desc = 'Copilot Chat Save' })
        end;
    }
}
