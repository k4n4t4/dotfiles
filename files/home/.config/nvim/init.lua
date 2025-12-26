if vim.g.vscode then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")
