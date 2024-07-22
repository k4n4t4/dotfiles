return {
  {
    "MeanderingProgrammer/markdown.nvim",
    name = "render-markdown",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    ft = "markdown",
    config = function()
      require("render-markdown").setup {
        heading = {
          enabled = true,
        },
        code = {
          enabled = true,
        },
        dash = {
          enabled = true,
        },
        bullet = {
          enabled = true,
        },
        checkbox = {
          enabled = true,
        },
        quote = {
          enabled = true,
        },
        pipe_table = {
          enabled = true,
        },
        callout = {
          enabled = true,
        },
        link = {
          enabled = true,
        },
        sign = {
          enabled = true,
        },
      }
    end,
  },
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    ft = "markdown",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    enabled = false,
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~/vaults/personal",
        },
        {
          name = "work",
          path = "~/vaults/work",
        },
      },
    },
  },
}
