local group = vim.api.nvim_create_augroup("Ready", { clear = true })

vim.api.nvim_create_autocmd("UIEnter", {
    group = group,
    once = true,
    callback = function()
        vim.schedule(function()
            vim.schedule(function()
                vim.api.nvim_exec_autocmds("User", { pattern = "Ready", modeline = false })
            end)
        end)
    end,
})
