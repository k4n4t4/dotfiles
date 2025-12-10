local group = vim.api.nvim_create_augroup("toggle_relative_number", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


-- toggle relativenumber when enter insert mode
autocmd("InsertEnter", {
  group = group;
  callback = function()
    vim.opt.relativenumber = false
  end;
})

autocmd("InsertLeave", {
  group = group;
  callback = function()
    vim.opt.relativenumber = true
  end;
})
