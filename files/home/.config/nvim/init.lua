vim.loader.enable()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")


local group = vim.api.nvim_create_augroup("UIEnterPost", { clear = true })

vim.api.nvim_create_autocmd("UIEnter", {
    group = group,
    once = true,
    callback = function()
        vim.schedule(function()
            vim.api.nvim_exec_autocmds("User", { pattern = "UIEnterPost", modeline = false })
        end)
    end,
})
