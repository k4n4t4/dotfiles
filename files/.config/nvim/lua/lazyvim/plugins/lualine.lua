return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "yorik1984/lualine-theme.nvim"
  },
  config = function()
    require("lualine").setup({
      options = {
        icons_enabled = true,
        theme = "newpaper-dark",
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
      }
    })
  end
}
