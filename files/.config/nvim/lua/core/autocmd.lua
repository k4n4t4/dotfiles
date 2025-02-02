local group = vim.api.nvim_create_augroup("Settings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


autocmd("BufWinLeave", {
  group = group,
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.cmd [[mkview]]
    end
  end
})
autocmd("BufWinEnter", {
  group = group,
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.cmd [[silent! loadview]]
    end
  end
})


if vim.o.number and vim.o.relativenumber then
  autocmd("InsertEnter", {
    group = group,
    callback = function()
      if vim.wo.number then
        vim.opt_local.relativenumber = false
      end
    end
  })
  autocmd("InsertLeave", {
    group = group,
    callback = function()
      if vim.wo.number then
        vim.opt_local.relativenumber = true
      end
    end
  })
end


autocmd("BufEnter", {
  group = group,
  callback = function()
    if vim.fn.getcmdwintype() ~= "" then
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.signcolumn = "no"
    end
  end
})


autocmd("TermOpen", {
  group = group,
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.signcolumn = "no"
    vim.cmd [[startinsert]]
  end
})


autocmd("TextYankPost", {
  group = group,
  callback = function()
    vim.highlight.on_yank { hlgroup = "Visual", timeout = 300 }
  end
})


autocmd("BufEnter", {
  group = group,
  callback = function(args)
    local bufname = vim.api.nvim_buf_get_name(args.buf)
    local stat = vim.uv.fs_stat(bufname)
    if stat and stat.type == "directory" then
      vim.api.nvim_exec_autocmds("User", { pattern = "DirEnter" })
    end
  end
})


-- fcitx
if vim.fn.executable("fcitx5") == 1 then
  autocmd("InsertLeave", {
    group = group,
    callback = function()
      local out = vim.fn.system { "fcitx5-remote" }
      if out == "2\n" then
        vim.fn.system { "fcitx5-remote", "-c" }
      end
    end
  })
end
