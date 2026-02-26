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
-- local src = vim.fn.stdpath("config") .. "/lua/test.lua"
-- local cache_dir = vim.fn.stdpath("cache") .. "/compiled/"
-- local out_path = cache_dir .. "test.luac"
--
-- local f = io.open(out_path, "wb")
-- if f then
--     f:write(compiler.compile(src))
--     f:close()
--     vim.notify("[compile] compiled successfully", vim.log.levels.INFO)
-- else
--     vim.notify("[compile] cannot open", vim.log.levels.WARN)
-- end
--
-- print(compiler.load(out_path))
