local autocmd = vim.api.nvim_create_autocmd


autocmd("BufWinLeave", {
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.api.nvim_exec('mkview', false)
    end
  end
})
autocmd("BufRead", {
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.api.nvim_exec('loadview', false)
    end
  end
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
