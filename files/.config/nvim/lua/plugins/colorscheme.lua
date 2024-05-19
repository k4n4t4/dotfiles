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
      require('onedark').load()
      vim.cmd [[
        highlight Normal guibg=none, ctermbg=none
        highlight NonText guibg=none, ctermbg=none
        highlight LineNr guibg=none, ctermbg=none
        highlight Folded guibg=none, ctermbg=none
        highlight EndOfBuffer guibg=none, ctermbg=none
      ]]
    end,
  },
}
