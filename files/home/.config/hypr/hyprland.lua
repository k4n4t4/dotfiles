require "modules.settings"
require "modules.autostart"
require "modules.keybinds"

local ok, noctalia =  pcall(require, "noctalia")
if ok then noctalia.apply_theme() end
