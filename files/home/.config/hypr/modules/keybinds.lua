local MOD = "SUPER"
local LMB = "mouse:272"
local RMB = "mouse:273"

hl.bind(MOD .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(MOD .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))


local screenshots_dir = "~/pers/imgs/screenshots/"

hl.bind(MOD .. " + O", hl.dsp.exec_cmd("hyprshot -m output -o " .. screenshots_dir))
hl.bind(MOD .. " + CTRL + O", hl.dsp.exec_cmd("hyprshot -m region -o " .. screenshots_dir))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region -o " .. screenshots_dir))
hl.bind(MOD .. " + SHIFT + O", hl.dsp.exec_cmd("hyprshot -m window -o " .. screenshots_dir))
hl.bind(MOD .. " + ALT + O", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
hl.bind(MOD .. " + ALT + CTRL + O", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
hl.bind(MOD .. " + ALT + SHIFT + O", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))

hl.bind(MOD .. " + Q", hl.dsp.window.kill())

hl.bind(MOD .. " + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. " + D", hl.dsp.window.pseudo())
hl.bind(MOD .. " + G", hl.dsp.layout("togglesplit"))
hl.bind(MOD .. " + C", hl.dsp.window.center())
hl.bind("F11", hl.dsp.window.fullscreen({ action = "toggle" }))

hl.bind(MOD .. " + " .. LMB, hl.dsp.window.drag(), { mouse = true })
hl.bind(MOD .. " + " .. RMB, hl.dsp.window.resize(), { mouse = true })
hl.bind(MOD .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(MOD .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(MOD .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(MOD .. " + J", hl.dsp.focus({ direction = "d" }))
hl.bind(MOD .. " + CTRL + H", hl.dsp.window.swap({ direction = "l" }))
hl.bind(MOD .. " + CTRL + L", hl.dsp.window.swap({ direction = "r" }))
hl.bind(MOD .. " + CTRL + K", hl.dsp.window.swap({ direction = "u" }))
hl.bind(MOD .. " + CTRL + J", hl.dsp.window.swap({ direction = "d" }))
hl.bind(MOD .. " + SHIFT + H", hl.dsp.window.move({ direction = "l" }))
hl.bind(MOD .. " + SHIFT + L", hl.dsp.window.move({ direction = "r" }))
hl.bind(MOD .. " + SHIFT + K", hl.dsp.window.move({ direction = "u" }))
hl.bind(MOD .. " + SHIFT + J", hl.dsp.window.move({ direction = "d" }))
hl.bind(MOD .. " + ALT + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + ALT + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + ALT + K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
hl.bind(MOD .. " + ALT + J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
hl.bind(MOD .. " + SHIFT + ALT + H", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + SHIFT + ALT + L", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
hl.bind(MOD .. " + SHIFT + ALT + K", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
hl.bind(MOD .. " + SHIFT + ALT + J", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })
hl.bind(MOD .. " + TAB", hl.dsp.window.cycle_next({ next = true }), { repeating = true })
hl.bind(MOD .. " + SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }), { repeating = true })
hl.bind(MOD .. " + TAB", hl.dsp.window.alter_zorder({ mode = "top" }), { repeating = true })
hl.bind(MOD .. " + SHIFT + TAB", hl.dsp.window.alter_zorder({ mode = "top" }), { repeating = true })

hl.bind(MOD .. " + W", hl.dsp.submap("Window"))
hl.define_submap("Window", function()
    hl.bind("escape", hl.dsp.submap("reset"))

    hl.bind("F", hl.dsp.window.float({ action = "toggle" }))
    hl.bind("D", hl.dsp.window.pseudo())
    hl.bind("G", hl.dsp.layout("togglesplit"))
    hl.bind("C", hl.dsp.window.center())

    hl.bind("H", hl.dsp.window.move({ x = -20, y = 0, relative = true }), { repeating = true })
    hl.bind("L", hl.dsp.window.move({ x = 20, y = 0, relative = true }), { repeating = true })
    hl.bind("K", hl.dsp.window.move({ x = 0, y = -20, relative = true }), { repeating = true })
    hl.bind("J", hl.dsp.window.move({ x = 0, y = 20, relative = true }), { repeating = true })
    hl.bind("CTRL + H", hl.dsp.window.swap({ direction = "l" }))
    hl.bind("CTRL + L", hl.dsp.window.swap({ direction = "r" }))
    hl.bind("CTRL + K", hl.dsp.window.swap({ direction = "u" }))
    hl.bind("CTRL + J", hl.dsp.window.swap({ direction = "d" }))
    hl.bind("SHIFT + H", hl.dsp.window.move({ direction = "l" }))
    hl.bind("SHIFT + L", hl.dsp.window.move({ direction = "r" }))
    hl.bind("SHIFT + K", hl.dsp.window.move({ direction = "u" }))
    hl.bind("SHIFT + J", hl.dsp.window.move({ direction = "d" }))
    hl.bind("ALT + H", hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
    hl.bind("ALT + L", hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
    hl.bind("ALT + K", hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
    hl.bind("ALT + J", hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
    hl.bind("TAB", hl.dsp.window.cycle_next({ next = true }), { repeating = true })
    hl.bind("SHIFT + TAB", hl.dsp.window.cycle_next({ next = false }), { repeating = true })
end)


-- local raise_volume    = hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%")
-- local lower_volume    = hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%")
-- local mute_volume     = hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle")
-- local raise_mic       = hl.dsp.exec_cmd("pactl set-source-volume @DEFAULT_SOURCE@ +5%")
-- local lower_mic       = hl.dsp.exec_cmd("pactl set-source-volume @DEFAULT_SOURCE@ -5%")
-- local mute_mic        = hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle")
-- local brightness_up   = hl.dsp.exec_cmd("brightnessctl s +5%")
-- local brightness_down = hl.dsp.exec_cmd("brightnessctl s 5%-")

local raise_volume    = hl.dsp.exec_cmd("swayosd-client --output-volume raise")
local lower_volume    = hl.dsp.exec_cmd("swayosd-client --output-volume lower")
local mute_volume     = hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle")
local raise_mic       = hl.dsp.exec_cmd("swayosd-client --input-volume raise")
local lower_mic       = hl.dsp.exec_cmd("swayosd-client --input-volume lower")
local mute_mic        = hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle")
local brightness_up   = hl.dsp.exec_cmd("swayosd-client --brightness raise")
local brightness_down = hl.dsp.exec_cmd("swayosd-client --brightness lower")


hl.bind("XF86AudioRaiseVolume", raise_volume, { repeating = true })
hl.bind("XF86AudioLowerVolume", lower_volume, { repeating = true })
hl.bind("XF86AudioMute", mute_volume)
hl.bind("XF86AudioMicMute", mute_mic)
hl.bind("XF86MonBrightnessUp", brightness_up, { repeating = true })
hl.bind("XF86MonBrightnessDown", brightness_down, { repeating = true })

hl.bind(MOD .. " + A", hl.dsp.submap("Media"))
hl.define_submap("Media", function()
    hl.bind("escape", hl.dsp.submap("reset"))

    hl.bind("up", raise_volume, { repeating = true })
    hl.bind("k", raise_volume, { repeating = true })
    hl.bind("down", lower_volume, { repeating = true })
    hl.bind("j", lower_volume, { repeating = true })
    hl.bind("return", mute_volume)
    hl.bind("SHIFT + up", raise_mic, { repeating = true })
    hl.bind("SHIFT + k", raise_mic, { repeating = true })
    hl.bind("SHIFT + down", lower_mic, { repeating = true })
    hl.bind("SHIFT + j", lower_mic, { repeating = true })
    hl.bind("SHIFT + return", mute_mic)
    hl.bind("CTRL + up", brightness_up, { repeating = true })
    hl.bind("CTRL + k", brightness_up, { repeating = true })
    hl.bind("CTRL + down", brightness_down, { repeating = true })
    hl.bind("CTRL + j", brightness_down, { repeating = true })
end)

local terminal = "uwsm app -- kitty"
local browser = "uwsm app -- firefox"
local private_browser = "uwsm app -- firefox --private-window"
local launcher = "uwsm app -- wofi --show drun --run-command 'uwsm app -- %s'"
local clipboard_manager = "cliphist list | uwsm app -- wofi --dmenu | cliphist decode | wl-copy"
local system_menu = "uwsm app -- wlogout"
local task_manager = "uwsm app -- st -f 'ComicShannsMono Nerd Font Mono-14' -c float btop"
local lock_screen = "uwsm app -- hyprlock"

hl.bind(MOD .. " + ESCAPE", hl.dsp.exec_cmd(system_menu))
hl.bind(MOD .. " + X", hl.dsp.exec_cmd(lock_screen))
hl.bind(MOD .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(MOD .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(MOD .. " + V", hl.dsp.exec_cmd(clipboard_manager))
hl.bind(MOD .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(MOD .. " + P", hl.dsp.exec_cmd(private_browser))
hl.bind(MOD .. " + M", hl.dsp.exec_cmd(task_manager))

for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(MOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(MOD .. " + grave", hl.dsp.focus({ workspace = 11 }))
hl.bind(MOD .. " + SHIFT + grave", hl.dsp.window.move({ workspace = 11 }))

hl.bind(MOD .. " + S", hl.dsp.workspace.toggle_special("A"))
hl.bind(MOD .. " + CTRL + S", hl.dsp.workspace.toggle_special("B"))
hl.bind(MOD .. " + ALT + S", hl.dsp.workspace.toggle_special("C"))
hl.bind(MOD .. " + CTRL + ALT + S", hl.dsp.workspace.toggle_special("D"))
hl.bind(MOD .. " + left", hl.dsp.focus({ workspace = "-1" }), { repeating = true })
hl.bind(MOD .. " + right", hl.dsp.focus({ workspace = "+1" }), { repeating = true })

hl.bind(MOD .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:A" }))
hl.bind(MOD .. " + CTRL + SHIFT + S", hl.dsp.window.move({ workspace = "special:B" }))
hl.bind(MOD .. " + ALT + SHIFT + S", hl.dsp.window.move({ workspace = "special:C" }))
hl.bind(MOD .. " + CTRL + ALT + SHIFT + S", hl.dsp.window.move({ workspace = "special:D" }))
hl.bind(MOD .. " + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind(MOD .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })

hl.bind(MOD .. " + period", hl.dsp.layout("move +col"))
hl.bind(MOD .. " + comma", hl.dsp.layout("move -col"))
hl.bind(MOD .. " + SHIFT + period", hl.dsp.layout("movewindowto r"))
hl.bind(MOD .. " + SHIFT + comma", hl.dsp.layout("movewindowto l"))
hl.bind(MOD .. " + SHIFT + up", hl.dsp.layout("movewindowto u"))
hl.bind(MOD .. " + SHIFT + down", hl.dsp.layout("movewindowto d"))
