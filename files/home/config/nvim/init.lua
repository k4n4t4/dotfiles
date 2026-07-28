vim.loader.enable()

-- local time = vim.loop.hrtime()
-- vim.api.nvim_create_autocmd("SafeState", {
--     once = true,
--     callback = function()
--         local elapsed_ms = (vim.loop.hrtime() - time) / 1e6
--         vim.notify(string.format("Neovim loaded in %.2fms", elapsed_ms))
--     end,
-- })

if vim.g.vscode then
    require "vscode-nvim"
else
    if vim.g.neovide then
        require "neovide"
    end
    require "core"
    require "plugins"
end
