if vim.loader then vim.loader.enable() end

require "core"
require "lazyvim"
pcall(require, "config")
