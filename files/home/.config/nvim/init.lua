vim.loader.enable()

if vim.g.vscode then
    require "vscode-nvim"
else
    if vim.g.neovide then
        require "neovide"
    end
    require "core"
    require "plugins"
end
