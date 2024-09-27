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

if vim.opt.number and vim.opt.relativenumber then
  autocmd("InsertEnter", {
    callback = function()
      if vim.wo.number then
        vim.wo.relativenumber = false
      end
    end
  })
  autocmd("InsertLeave", {
    callback = function()
      if vim.wo.number then
        vim.wo.relativenumber = true
      end
    end
  })
end


autocmd("TermOpen", {
  callback = function()
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.wo.foldcolumn = '0'
    vim.wo.signcolumn = "no"
    vim.cmd [[startinsert]]
  end
})
