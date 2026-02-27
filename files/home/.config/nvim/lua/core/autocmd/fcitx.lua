vim.api.nvim_create_autocmd("User", {
    pattern = "Ready",
    once = true,
    callback = vim.schedule_wrap(function()
        local group = vim.api.nvim_create_augroup("fcitx5", { clear = true })

        if vim.fn.executable("fcitx5") == 1 then
            vim.api.nvim_create_autocmd("InsertLeave", {
                group = group,
                callback = function()
                    local out = vim.fn.system { "fcitx5-remote" }
                    if out == "2\n" then
                        vim.fn.system { "fcitx5-remote", "-c" }
                    end
                end,
            })
        end
    end),
})
