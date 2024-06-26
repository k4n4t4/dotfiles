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
      vim.cmd [[
        highlight Normal guibg=none, ctermbg=none
        highlight NonText guibg=none, ctermbg=none
        highlight LineNr guibg=none, ctermbg=none
        highlight SignColumn guibg=none, ctermbg=none
        highlight TabLine guibg=none, ctermbg=none
        highlight TabLineFill guibg=none, ctermbg=none
        highlight Folded guibg=none, ctermbg=none
        highlight EndOfBuffer guibg=none, ctermbg=none

        highlight NvimTreeNormal guibg=none, ctermbg=none
        highlight NvimTreeEndOfBuffer guibg=none, ctermbg=none
      ]]
    end,
  },
}
