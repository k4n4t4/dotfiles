if vim.loader then vim.loader.enable() end

require "core"
if not vim.g.vscode then
  require "lazyvim"
end
if vim.g.vscode then
  require "vscode-neovim"
end
pcall(require, "config")
