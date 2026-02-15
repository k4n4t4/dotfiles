local group = vim.api.nvim_create_augroup("fcitx5", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

if vim.fn.executable("fcitx5") == 1 then
    autocmd("InsertLeave", {
        group = group,
        callback = function()
            local out = vim.fn.system { "fcitx5-remote" }
            if out == "2\n" then
                vim.fn.system { "fcitx5-remote", "-c" }
            end
        end,
    })
end
