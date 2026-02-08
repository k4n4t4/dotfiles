local is_nixos = vim.fn.executable("nixos-version") == 1
local is_vscode = vim.g.vscode

if is_vscode then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")
