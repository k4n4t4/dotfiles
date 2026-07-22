require "modules.monitors"
require "modules.settings"
require "modules.animations"
require "modules.autostart"
require "modules.env"
require "modules.keybinds"

local ok, noctalia =  pcall(require, "noctalia")
if ok then noctalia.apply_theme() end
