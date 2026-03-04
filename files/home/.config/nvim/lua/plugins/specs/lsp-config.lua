return {
    {
        "neovim/nvim-lspconfig",
    },
    {
        "mason-org/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        event = "VeryLazy",
        config = function()
            require("mason").setup {
                ui = {
                    border = 'double',
                },
            }
        end,
    },
}
