return {
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "darker",
      transparent = true,
      ending_tildes = false,
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
