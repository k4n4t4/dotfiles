return {
    "folke/trouble.nvim",
    opts = {},
    cmd = "Trouble",
    keys = {
        {
            "<LEADER>xx",
            "<CMD>Trouble diagnostics toggle<cr>",
            desc = "Diagnostics (Trouble)",
        },
        {
            "<LEADER>xX",
            "<CMD>Trouble diagnostics toggle filter.buf=0<cr>",
            desc = "Buffer Diagnostics (Trouble)",
        },
        {
            "<LEADER>xs",
            "<CMD>Trouble symbols toggle focus=false<cr>",
            desc = "Symbols (Trouble)",
        },
        {
            "<LEADER>xl",
            "<CMD>Trouble lsp toggle focus=false win.position=right<cr>",
            desc = "LSP Definitions / references / ... (Trouble)",
        },
        {
            "<LEADER>xL",
            "<CMD>Trouble loclist toggle<cr>",
            desc = "Location List (Trouble)",
        },
        {
            "<LEADER>xQ",
            "<CMD>Trouble qflist toggle<cr>",
            desc = "Quickfix List (Trouble)",
        },
    },
}
