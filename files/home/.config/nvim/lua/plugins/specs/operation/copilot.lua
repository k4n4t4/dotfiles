return {
    {
        "zbirenbaum/copilot.lua";
        cmd = "Copilot";
        event = 'InsertEnter';
        opts = {
            filetypes = {
                ['*'] = true;
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
        cmd = "Copilot";
        event = 'InsertEnter';
        config = true;
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim";
        deprecations = {
            "zbirenbaum/copilot.lua";
            "nvim-lua/plenary.nvim";
        };
        build = "make tiktoken";
        opts = {
            window = {
                layout = "float";
                relative = "cursor";
            };
            debug = false;
        };
        keys = {
            { mode = { "n", "x" }, "<LEADER>::", "<CMD>CopilotChatToggle<CR>", desc = "Copilot Chat Toggle" },
            { mode = { "n", "x" }, "<LEADER>:c", "<CMD>CopilotChatOpen<CR>", desc = "Copilot Chat Open" },
            { mode = { "n", "x" }, "<LEADER>:q", "<CMD>CopilotChatClose<CR>", desc = "Copilot Chat Close" },
            { mode = { "n", "x" }, "<LEADER>:r", "<CMD>CopilotChatReset<CR>", desc = "Copilot Chat Reset" },
            { mode = { "n", "x" }, "<LEADER>:s", "<CMD>CopilotChatStop<CR>", desc = "Copilot Chat Stop" },
            { mode = { "n", "x" }, "<LEADER>:w", "<CMD>CopilotChatSave<CR>", desc = "Copilot Chat Save" },
            { mode = { "n", "x" }, "<LEADER>:l", "<CMD>CopilotChatLoad<CR>", desc = "Copilot Chat Load" },
            { mode = { "n", "x" }, "<LEADER>:p", "<CMD>CopilotChatPrompts<CR>", desc = "Copilot Chat Prompts" },
            { mode = { "n", "x" }, "<LEADER>:d", "<CMD>CopilotChatDocs<CR>", desc = "Copilot Chat Docs" },
            { mode = { "n", "x" }, "<LEADER>:x", "<CMD>CopilotChatExplain<CR>", desc = "Copilot Chat Explain" },
            { mode = { "n", "x" }, "<LEADER>:f", "<CMD>CopilotChatFix<CR>", desc = "Copilot Chat Fix" },
            { mode = { "n", "x" }, "<LEADER>:o", "<CMD>CopilotChatOptimize<CR>", desc = "Copilot Chat Optimize" },
            { mode = { "n", "x" }, "<LEADER>:t", "<CMD>CopilotChatTests<CR>", desc = "Copilot Chat Tests" },
            { mode = { "n", "x" }, "<LEADER>:a", "<CMD>CopilotChatAgents<CR>", desc = "Copilot Chat Agents" },
            { mode = { "n", "x" }, "<LEADER>:m", "<CMD>CopilotChatModels<CR>", desc = "Copilot Chat Models" },
            { mode = { "n", "x" }, "<LEADER>:v", "<CMD>CopilotChatReview<CR>", desc = "Copilot Chat Review" },
            { mode = { "n", "x" }, "<LEADER>:cC", "<CMD>CopilotChatCommit<CR>", desc = "Copilot Chat Commit" },
        };
        cmd = {
            "CopilotChat",
            "CopilotChatOpen",
            "CopilotChatClose",
            "CopilotChatToggle",
            "CopilotChatStop",
            "CopilotChatReset",
            "CopilotChatSave",
            "CopilotChatLoad",
            "CopilotChatPrompts",
            "CopilotChatModels",
            "CopilotChatAgents",
            "CopilotChatExplain",
            "CopilotChatReview",
            "CopilotChatFix",
            "CopilotChatOptimize",
            "CopilotChatDocs",
            "CopilotChatTests",
            "CopilotChatCommit",
        };
    }
}
