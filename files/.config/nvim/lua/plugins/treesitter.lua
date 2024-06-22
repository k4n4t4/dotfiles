return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    main = "nvim-treesitter.configs",
    config = function ()
      require("nvim-treesitter").setup {
        highlight = {
          enable = true,
          disable = {},
        },
      }
      vim.opt.foldenable = true
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
