return {
  {
    "navarasu/onedark.nvim",
    enabled = false,
    opts = {
      style = "darker",
    },
    config = function()
      vim.cmd.colorscheme "onedark"
    end,
  },
  {
    "catppuccin/nvim",
    enabled = false,
    name = "catppuccin",
    config = function()
      vim.cmd.colorscheme "catppuccin"
    end,
  },
  {
    "folke/tokyonight.nvim",
    enabled = true,
    config = function()
      vim.cmd.colorscheme "tokyonight"
    end,
  },
}
