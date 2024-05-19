return {
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
      transparent = true,
      lualine = {
          transparent = true,
      },
    },
    config = function()
      vim.cmd "colorscheme onedark"
      vim.cmd "hi Normal guibg = None"
    end,
  },
}
