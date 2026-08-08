vim.loader.enable()

if vim.g.vscode then
    require "vscode-nvim"
    return
end

if vim.g.neovide then
    require "neovide"
end

require "core"
require "plugins"
