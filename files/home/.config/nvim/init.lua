if vim.loader then vim.loader.enable() end

require "core"
if not vim.g.vscode then
  require "lazyvim"
end
pcall(require, "config")
