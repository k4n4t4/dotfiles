if vim.loader then vim.loader.enable() end

if vim.g.vscode then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")
