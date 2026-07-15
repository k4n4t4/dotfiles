vim.loader.enable()

if vim.g.vscode == 1 then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end
