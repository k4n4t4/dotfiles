return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        {
            "mason-org/mason.nvim",
            opts = {
                ui = {
                    border = 'double',
                },
            },
        },
        "neovim/nvim-lspconfig",
    },
    event = "VeryLazy",
    config = function()
        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup {
            ensure_installed = {
                "vimls",
            },
            automatic_enable = false,
        }
    end,
}
