local group = vim.api.nvim_create_augroup("terminal_ettings", { clear = true })
local autocmd = vim.api.nvim_create_autocmd


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
