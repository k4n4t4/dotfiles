return {
    {
        "zbirenbaum/copilot.lua";
        cmd = "Copilot";
        event = 'VeryLazy';
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
        opts = {
            window = {
                layout = "float";
                relative = "cursor";
            };
            debug = false;
        };
        keys = {
            { mode = { "n", "x" }, "<LEADER>ct", "<CMD>CopilotChatToggle<CR>", desc = "Copilot Chat Toggle" },
            { mode = { "n", "x" }, "<LEADER>c:", "<CMD>CopilotChatOpen<CR>", desc = "Copilot Chat Open" },
            { mode = { "n", "x" }, "<LEADER>cq", "<CMD>CopilotChatClose<CR>", desc = "Copilot Chat Close" },
            { mode = { "n", "x" }, "<LEADER>cr", "<CMD>CopilotChatReset<CR>", desc = "Copilot Chat Reset" },
            { mode = { "n", "x" }, "<LEADER>cs", "<CMD>CopilotChatStop<CR>", desc = "Copilot Chat Stop" },
            { mode = { "n", "x" }, "<LEADER>cw", "<CMD>CopilotChatSave<CR>", desc = "Copilot Chat Save" },
            { mode = { "n", "x" }, "<LEADER>cl", "<CMD>CopilotChatLoad<CR>", desc = "Copilot Chat Load" },
            { mode = { "n", "x" }, "<LEADER>cp", "<CMD>CopilotChatPrompts<CR>", desc = "Copilot Chat Prompts" },
            { mode = { "n", "x" }, "<LEADER>cd", "<CMD>CopilotChatDocs<CR>", desc = "Copilot Chat Docs" },
            { mode = { "n", "x" }, "<LEADER>cx", "<CMD>CopilotChatExplain<CR>", desc = "Copilot Chat Explain" },
            { mode = { "n", "x" }, "<LEADER>cf", "<CMD>CopilotChatFix<CR>", desc = "Copilot Chat Fix" },
            { mode = { "n", "x" }, "<LEADER>co", "<CMD>CopilotChatOptimize<CR>", desc = "Copilot Chat Optimize" },
            { mode = { "n", "x" }, "<LEADER>cT", "<CMD>CopilotChatTests<CR>", desc = "Copilot Chat Tests" },
            { mode = { "n", "x" }, "<LEADER>cA", "<CMD>CopilotChatAgents<CR>", desc = "Copilot Chat Agents" },
            { mode = { "n", "x" }, "<LEADER>cM", "<CMD>CopilotChatModels<CR>", desc = "Copilot Chat Models" },
            { mode = { "n", "x" }, "<LEADER>cR", "<CMD>CopilotChatReview<CR>", desc = "Copilot Chat Review" },
            { mode = { "n", "x" }, "<LEADER>cC", "<CMD>CopilotChatCommit<CR>", desc = "Copilot Chat Commit" },
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
