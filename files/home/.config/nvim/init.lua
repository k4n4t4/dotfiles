vim.loader.enable()


require "core"


--[[ GENERAL SETTINGS ]]--

-- default shell
vim.opt.shell = "fish"

-- transparent
require("utils.transparent").enable()

-- line number
vim.opt.number = true
vim.opt.relativenumber = false
require("utils.toggle_relnumber").enable()

-- mouse
vim.opt.mouse = "a"


--[[ BUILTIN PLUGINS ]]--

-- disable builtin plugins
vim.opt.loadplugins = false

-- enable man plugin
vim.cmd.runtime("plugin/man.lua")
