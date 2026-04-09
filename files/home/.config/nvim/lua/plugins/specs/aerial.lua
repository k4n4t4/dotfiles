return {
    'stevearc/aerial.nvim',
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
        { "<leader>ot", "<cmd>AerialToggle<CR>",    desc = "Toggle Aerial" },
        { "<leader>on", "<cmd>AerialNavToggle<CR>", desc = "Toggle AerialNav" },
    },
    config = function()

        require("aerial").setup {
            backends = { "lsp", "treesitter", "markdown", "asciidoc" },
            filter_kind = false,
            layout = {
                max_width = { 80, 0.5 },
                width = 0.3,
                default_direction = "float",
            },
            float = {
                border = "none",
                override = function(conf, winid)
                    vim.wo[winid].winblend = 10
                    return conf
                end
            },
            nav = {
                border = "none",
                win_opts = {
                    winblend = 10,
                },
                keymaps = {
                    ["q"] = "actions.close",
                },
            },
        }
    end,
}
