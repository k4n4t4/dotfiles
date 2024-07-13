local autocmd = vim.api.nvim_create_autocmd

autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})
