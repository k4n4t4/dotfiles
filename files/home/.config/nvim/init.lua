vim.loader.enable()
require"utils.startup_time".setup({ show = false })
require"utils.disable_plugins".setup()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")
