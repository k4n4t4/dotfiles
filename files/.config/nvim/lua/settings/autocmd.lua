local autocmd = vim.api.nvim_create_autocmd


autocmd("BufWinLeave", {
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.api.nvim_exec('mkview', false)
    end
  end
})
autocmd("BufWinEnter", {
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.api.nvim_exec('silent! loadview', false)
    end
  end
})

autocmd("InsertEnter", {
  callback = function()
    vim.wo.relativenumber = false
  end
})
autocmd("InsertLeave", {
  callback = function()
    vim.wo.relativenumber = true
  end
})
