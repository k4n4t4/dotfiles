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
