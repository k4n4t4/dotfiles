local autocmd = vim.api.nvim_create_autocmd

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

autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

autocmd("InsertEnter", {
  callback = function()
    vim.opt.relativenumber = false
  end
})
autocmd("InsertLeave", {
  callback = function()
    vim.opt.relativenumber = true
  end
})
autocmd("CmdlineEnter", {
  callback = function()
    vim.opt.cmdheight = 1
  end
})
autocmd("CmdlineLeave", {
  callback = function()
    vim.opt.cmdheight = 0
  end
})
