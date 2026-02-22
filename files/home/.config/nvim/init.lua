vim.loader.enable()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

vim.api.nvim_create_autocmd("VimEnter", {
    once = true,
    callback = function()
        pcall(require, "config")
    end,
})
