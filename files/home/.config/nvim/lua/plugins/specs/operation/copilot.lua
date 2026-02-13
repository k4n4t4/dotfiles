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

            vim.api.nvim_create_augroup("CopilotChatNoNumber", { clear = true })
            vim.api.nvim_create_autocmd("FileType", {
                group = "CopilotChatNoNumber";
                pattern = "copilot-chat";
                callback = function()
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false
                    vim.opt_local.signcolumn = "no"
                end;
            })

            require("CopilotChat").setup {
                window = {
                    layout = 'vertical';
                    width = 0.4;
                };
                debug = false;
                question_header = '## User ';
                answer_header = '## Copilot ';
                error_header = '## Error ';
                prompts = {
                    Explain = {
                        prompt = "/COPILOT_EXPLAIN Please explain the code in " .. language .. ".";
                        mapping = '<leader>ce';
                        description = "Ask for code explanation";
                    };
                    Review = {
                        prompt = '/COPILOT_REVIEW Please review the code in ' .. language .. '.';
                        mapping = '<leader>cv';
                        description = "Ask for code review";
                    };
                    Fix = {
                        prompt = "/COPILOT_FIX There is a problem with this code. Please show the fixed code and explain in " .. language .. ".";
                        mapping = '<leader>cf';
                        description = "Ask for code fix";
                    };
                    Optimize = {
                        prompt = "/COPILOT_REFACTOR Please optimize the selected code for performance and readability, and explain in " .. language .. ".";
                        mapping = '<leader>co';
                        description = "Ask for code optimization";
                    };
                    Docs = {
                        prompt = "/COPILOT_GENERATE Please generate documentation comments for the selected code in " .. language .. ".";
                        mapping = '<leader>cg';
                        description = "Ask for code documentation";
                    };
                    Tests = {
                        prompt = "/COPILOT_TESTS Please write detailed unit tests for the selected code and explain in " .. language .. ".";
                        mapping = '<leader>cd';
                        description = "Ask for test code";
                    };
                    FixDiagnostic = {
                        prompt = 'Please fix the issues according to the code diagnostics and explain the changes in ' .. language .. '.';
                        mapping = '<leader>cF';
                        description = "Ask for code fix";
                        selection = require('CopilotChat.select').diagnostics;
                    };
                };
            };

            vim.keymap.set('n', '<leader>cc', '<CMD>CopilotChatOpen<CR>', { desc = 'Copilot Chat Open' })
            vim.keymap.set('n', '<leader>ct', '<CMD>CopilotChatToggle<CR>', { desc = 'Copilot Chat Toggle' })
            vim.keymap.set('n', '<leader>cq', '<CMD>CopilotChatClose<CR>', { desc = 'Copilot Chat Close' })
            vim.keymap.set('n', '<leader>cs', '<CMD>CopilotChatStop<CR>', { desc = 'Copilot Chat Stop' })
            vim.keymap.set('n', '<leader>cr', '<CMD>CopilotChatReset<CR>', { desc = 'Copilot Chat Reset' })
            vim.keymap.set('n', '<leader>cS', '<CMD>CopilotChatSave<CR>', { desc = 'Copilot Chat Save' })
        end;
    }
}
