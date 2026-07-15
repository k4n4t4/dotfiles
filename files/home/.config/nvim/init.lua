vim.loader.enable()

if vim.g.vscode == 1 then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

local transparent = require "utils.transparent"
transparent.setup()
vim.keymap.set("n", "<leader>T", function()
    transparent.toggle()
end, { desc = "Toggle Transparent" })
