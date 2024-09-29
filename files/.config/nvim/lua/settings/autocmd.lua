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


if vim.opt.number["_value"] and vim.opt.relativenumber["_value"] then
  autocmd("InsertEnter", {
    callback = function()
      if vim.opt_local.number["_value"] then
        vim.opt_local.relativenumber = false
      end
    end
  })
  autocmd("InsertLeave", {
    callback = function()
      if vim.opt_local.number["_value"] then
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


if vim.opt.cmdheight._value == 0 then
  autocmd("CmdlineEnter", {
    callback = function()
      vim.opt_local.cmdheight = 1
    end
  })
  autocmd("CmdlineLeave", {
    callback = function()
      vim.opt_local.cmdheight = 0
    end
  })
end


autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.signcolumn = "no"
    vim.cmd [[startinsert]]
  end
})
