return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    opts = {
      highlight = {
        enable = true,
        disable = {},
      },
    },
  },
  {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "CursorMoved",
    },
  }
}
