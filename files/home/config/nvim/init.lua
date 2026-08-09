vim.loader.enable()

if vim.g.vscode then
    require "hosts.vscode"
    return
end

if vim.g.neovide then
    require "hosts.neovide"
end

require "core"
require "plugins"
