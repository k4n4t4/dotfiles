return {
    -- colorschemes
    {
        "k4n4t4/theme.nvim",
        name = "k4n4t4",
    },
    {
        "navarasu/onedark.nvim",
        opts = {
            style = "darker",
        },
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
    },
    {
        "folke/tokyonight.nvim",
    },
    {
        "sainnhe/everforest",
        config = function()
            vim.g.everforest_background = 'soft'
        end
    },
    {
        "sainnhe/gruvbox-material",
        config = function()
            vim.g.gruvbox_material_background = 'medium'
        end
    },
    {
        "EdenEast/nightfox.nvim",
        opts = {
            options = {
                styles = {
                    comments = "italic",
                    keywords = "bold",
                    types = "italic,bold",
                },
            },
        },
    },
    {
        "tomasiser/vim-code-dark",
    },
    {
        "Mofiqul/vscode.nvim",
    },
}
