return {
  {
    "navarasu/onedark.nvim",
    enabled = false,
    opts = {
      style = "darker",
      transparent = true,
      lualine = {
          transparent = true,
      },
    },
    config = function()
      require("onedark").load()
    end,
  },
  {
    "catppuccin/nvim",
    enabled = true,
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  }
}
