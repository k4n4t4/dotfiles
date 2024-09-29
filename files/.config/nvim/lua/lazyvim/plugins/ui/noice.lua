return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    enabled = true,
    event = "VeryLazy",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    enabled = true,
    event = "VeryLazy",
    opts = {
      background_colour = "#000000",
    },
  },
}
