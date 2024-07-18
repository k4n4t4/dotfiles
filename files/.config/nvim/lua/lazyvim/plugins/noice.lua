return {
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    enabled = false,
    event = "VeryLazy",
    config = true,
  },
  {
    "rcarriga/nvim-notify",
    enabled = false,
    event = "VeryLazy",
    opts = {
      background_colour = "#000000",
    },
  },
}
