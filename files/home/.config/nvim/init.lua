vim.loader.enable()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")


-- TEST: compile and load a lua file

-- local compiler = require("utils.compiler")
-- local src = vim.fn.stdpath("config") .. "/lua/config.lua"
--
-- local result = compiler.cached_require(src)
