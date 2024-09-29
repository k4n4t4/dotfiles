return {

  -- colorschemes
  {
    "navarasu/onedark.nvim",
    enabled = false,
    opts = {
      style = "darker",
    },
  },
  {
    "catppuccin/nvim",
    enabled = false,
    name = "catppuccin",
  },
  {
    "folke/tokyonight.nvim",
    enabled = false,
  },

  -- highlights
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
    event = "VeryLazy",
  },

  {
    "dstein64/vim-startuptime",
    event = "VeryLazy",
  },

}
