local group = vim.api.nvim_create_augroup("Settings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


-- highlight yank area
autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.highlight.on_yank { hlgroup = "Visual", timeout = 150 }
    end,
})


-- restore cursor position
autocmd("BufReadPost", {
    group = group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})


-- User DirEnter
autocmd("BufEnter", {
    group = group,
    callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        local stat = vim.uv.fs_stat(bufname)
        if stat and stat.type == "directory" then
            vim.api.nvim_exec_autocmds("User", { pattern = "DirEnter", modeline = false })
        end
    end,
})

vim.api.nvim_create_autocmd("UIEnter", {
    group = group,
    callback = vim.schedule_wrap(function()
        vim.api.nvim_exec_autocmds("User", { pattern = "UIEnterPost", modeline = false })
    end)
})
