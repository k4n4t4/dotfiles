return {
  {
    "navarasu/onedark.nvim",
    enabled = true,
    opts = {
      style = "darker",
    },
  },
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
  },

  {
    "fladson/vim-kitty",
    ft = "kitty",
  },
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    ft = "markdown",
  },

  {
    "norcalli/nvim-colorizer.lua",
    enabled = true,
    event = "VeryLazy",
    config = true,
  },
}
