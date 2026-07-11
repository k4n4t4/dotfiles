return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        event = 'User Ready',
        config = function()
            require("treesitter-context").setup { enable = true }
            local hi = require "utils.highlight"
            hi.set("TreesitterContext", { bg = hi.ref("WinSeparator", "fg") })
        end,
    },
}
