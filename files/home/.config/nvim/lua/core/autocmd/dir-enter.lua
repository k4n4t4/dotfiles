local group = vim.api.nvim_create_augroup("DirEnter", { clear = true })

vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
        local bufname = vim.api.nvim_buf_get_name(args.buf)
        local stat = vim.uv.fs_stat(bufname)
        if stat and stat.type == "directory" then
            vim.api.nvim_exec_autocmds("User", { pattern = "DirEnter", modeline = false })
        end
    end,
})
