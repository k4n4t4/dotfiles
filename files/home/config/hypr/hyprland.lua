require "modules.settings"
require "modules.autostart"
require "modules.keybinds"

--[[
require("noctalia").apply_theme()
]]

local ok, noctalia = pcall(require, "noctalia")
if ok then noctalia.apply_theme() end
