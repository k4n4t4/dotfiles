return {

  -- colorschemes
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
    event = 'VeryLazy',
  },

  {
    "dstein64/vim-startuptime",
    event = 'VeryLazy',
  },

}
