return {
  {
    "navarasu/onedark.nvim",
    enabled = true,
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
}
