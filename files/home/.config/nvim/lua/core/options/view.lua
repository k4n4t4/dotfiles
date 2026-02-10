local group = vim.api.nvim_create_augroup("remember_view", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

vim.opt.viewoptions = {
    "folds",
    "cursor",
}

-- make view
autocmd("BufWinLeave", {
    group = group;
    callback = function()
        -- whether the current buffer is associated with a file
        if vim.fn.expand("%:p") ~= "" then
            vim.cmd [[mkview]]
        end
    end;
})

-- load view
autocmd("BufWinEnter", {
    group = group;
    callback = function(args)
        if vim.fn.expand("%:p") ~= "" then
            vim.schedule(function()
                if not vim.api.nvim_buf_is_valid(args.buf) or
                    vim.api.nvim_get_current_buf() ~= args.buf then
                    return
                end
                vim.cmd [[silent! loadview]]
            end)
        end
    end
})
