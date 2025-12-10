local group_name = "toggle_relative_number"

local group = vim.api.nvim_create_augroup(group_name, { clear = true })
local autocmd = vim.api.nvim_create_autocmd


-- toggle relativenumber when enter insert mode
autocmd("InsertEnter", {
  group = group;
  callback = function()
    vim.opt_local.relativenumber = false
  end;
})

autocmd("InsertLeave", {
  group = group;
  callback = function()
    vim.opt_local.relativenumber = true
  end;
})
