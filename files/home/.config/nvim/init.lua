local info = require "utils.info"

if info.is.vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")
