return {
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        lazy = false,
    },
    {
        "mason-org/mason.nvim",
        dependencies = {
            "neovim/nvim-lspconfig",
        },
        config = function()
            require("mason").setup {
                ui = {
                    border = 'double',
                },
            }
        end,
        cmd = {
            "Mason",
            "MasonInstall",
            "MasonUninstall",
            "MasonUninstallAll",
            "MasonLog",
            "MasonUpdate",
        },
    },
}
