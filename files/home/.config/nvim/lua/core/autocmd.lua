local group = vim.api.nvim_create_augroup("Settings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


-- make view
autocmd("BufWinLeave", {
  group = group;
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.cmd [[mkview]]
    end
  end;
})
-- load view
autocmd("BufWinEnter", {
  group = group;
  callback = function()
    if vim.fn.expand("%") ~= "" then
      vim.cmd [[silent! loadview]]
    end
  end;
})


-- toggle relativenumber when enter insert mode
if vim.o.number and vim.o.relativenumber then
  autocmd("InsertEnter", {
    group = group;
    callback = function()
      if vim.wo.number then
        vim.opt_local.relativenumber = false
      end
    end;
  })
  autocmd("InsertLeave", {
    group = group;
    callback = function()
      if vim.wo.number then
        vim.opt_local.relativenumber = true
      end
    end;
  })
end


-- hide column
autocmd("BufEnter", {
  group = group;
  callback = function()
    if vim.fn.getcmdwintype() ~= "" then
      vim.opt_local.foldcolumn = '0'
      vim.opt_local.signcolumn = "no"
    end
  end;
})


-- terminal settings
autocmd("TermOpen", {
  group = group;
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
    vim.opt_local.foldcolumn = '0'
    vim.opt_local.signcolumn = "no"
    vim.cmd [[startinsert]]
  end;
})
autocmd("TermClose", {
  group = group;
  pattern = 'term://*fish';
  callback = function()
    vim.api.nvim_input("<CR>")
  end;
})
autocmd("BufEnter", {
  group = group;
  pattern = 'term://*';
  callback = function()
    vim.cmd [[startinsert]]
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

-- indent size
autocmd("FileType", {
  group = group;
  pattern = { "java" };
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.softtabstop = 4
    vim.opt_local.shiftwidth = 4
  end;
})

-- fcitx
if vim.fn.executable("fcitx5") == 1 then
  autocmd("InsertLeave", {
    group = group;
    callback = function()
      local out = vim.fn.system { "fcitx5-remote" }
      if out == "2\n" then
        vim.fn.system { "fcitx5-remote", "-c" }
      end
    end;
  })
end
