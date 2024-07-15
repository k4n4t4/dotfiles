return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function ()
      require("nvim-treesitter.configs").setup {
        highlight = {
          enable = true,
          disable = {},
        },
      }
      vim.opt.foldenable = false
      vim.opt.foldmethod = "expr"
      vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    end
  },
  {
    {
      "nvim-treesitter/nvim-treesitter-textobjects",
      event = "CursorMoved",
    },
  }
}
