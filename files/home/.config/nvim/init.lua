vim.loader.enable()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

require"utils.compiler".manifest_require(vim.fn.stdpath("config") .. "/lua/config.lua")
