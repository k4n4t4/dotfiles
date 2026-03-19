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
}
