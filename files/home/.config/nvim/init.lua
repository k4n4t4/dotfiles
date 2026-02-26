vim.loader.enable()

local info = require "utils.info"

if info.env.is_vscode() then
    require "vscode-nvim"
else
    require "core"
    require "plugins"
end

pcall(require, "config")


-- TEST:

local compiler = require("utils.compiler")
local src = vim.fn.stdpath("config") .. "/lua/test.lua"
local cache_dir = vim.fn.stdpath("cache") .. "/compiled/"

assert(compiler.load(cache_dir, src)[1] == "Hello, Compiler!")
