local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.cmd.highlight { "Normal",      "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "NonText",     "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "LineNr",      "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "SignColumn",  "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "TabLine",     "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "TabLineFill", "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "Folded",      "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "EndOfBuffer", "guibg=none", "ctermbg=none" }

    vim.cmd.highlight { "NvimTreeNormal",      "guibg=none", "ctermbg=none" }
    vim.cmd.highlight { "NvimTreeEndOfBuffer", "guibg=none", "ctermbg=none" }
  end,
})
