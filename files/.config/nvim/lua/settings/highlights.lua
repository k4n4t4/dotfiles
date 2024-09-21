vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd.highlight {
      "Folded",
      "guibg=black",
      "ctermbg=black",
      "guifg=gray",
      "ctermfg=gray",
    }
    vim.cmd.highlight {
      "FoldColumn",
      "guibg=none",
      "ctermbg=none",
      "guifg=gray",
      "ctermfg=gray",
    }
  end
})
