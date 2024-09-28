require "settings"

vim.defer_fn(function()
  require "lazyvim"
  require "config"
end, 0)
