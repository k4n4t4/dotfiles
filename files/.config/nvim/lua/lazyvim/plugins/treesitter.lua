return {
  {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    cmd = {
      "TSUpdate",
      "TSInstall",
      "TSUninstall",
      "TSToggle",
      "TSEnable",
      "TSDisable",
      "TSBufToggle",
      "TSBufEnable",
      "TSBufDisable",
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = {
          "lua",
          "vim",
          "vimdoc",
          "query",
        },
        highlight = {
          enable = true,
          disable = {},
        },
        indent = {
          enable = true,
        },
      }
    end
  },
}
