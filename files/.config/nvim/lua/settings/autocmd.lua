local autocmd = vim.api.nvim_create_autocmd


autocmd("BufWinLeave", {
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.cmd [[mkview]]
    end
  end
})
autocmd("BufWinEnter", {
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.cmd [[silent! loadview]]
    end
  end
})


if vim.opt.number:get() and vim.opt.relativenumber:get() then
  autocmd("InsertEnter", {
    callback = function()
      if vim.opt_local.number:get() then
        vim.opt_local.relativenumber = false
      end
    end
  })
  autocmd("InsertLeave", {
    callback = function()
      if vim.opt_local.number:get() then
        vim.opt_local.relativenumber = true
      end
    end
  })
end


autocmd("BufEnter", {
  callback = function()
    if vim.fn.getcmdwintype() ~= "" then
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.signcolumn = "no"
    end
  end
})


autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.signcolumn = "no"
    vim.cmd [[startinsert]]
  end
})


autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank { hlgroup = "Visual", timeout = 300 }
  end
})
