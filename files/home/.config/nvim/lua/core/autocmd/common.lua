local group = vim.api.nvim_create_augroup("Settings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


-- hide column when command line window
autocmd("BufEnter", {
  group = group;
  callback = function()
    if vim.fn.getcmdwintype() ~= "" then
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.signcolumn = "no"
    end
  end;
})


-- highlight yank area
autocmd("TextYankPost", {
  group = group;
  callback = function()
    vim.highlight.on_yank { hlgroup = "Visual", timeout = 150 }
  end;
})


-- emit direnter
autocmd("BufEnter", {
  group = group;
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    local stat = vim.uv.fs_stat(bufname)
    if stat and stat.type == "directory" then
      vim.api.nvim_exec_autocmds("User", { pattern = "DirEnter" })
    end
  end;
})
