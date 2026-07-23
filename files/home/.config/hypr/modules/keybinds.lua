local MOD = "SUPER"
local LMB = "mouse:272"
local RMB = "mouse:273"


-- Hyprland control bindings
hl.bind(MOD .. " + SHIFT + Q", hl.dsp.exec_cmd("uwsm stop"))
hl.bind(MOD .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MOD .. " + Q", hl.dsp.window.close())
hl.bind(MOD .. " + ALT + Q", hl.dsp.window.kill())
hl.bind(MOD .. " + F", hl.dsp.window.float())
hl.bind(MOD .. " + C", hl.dsp.window.center())
hl.bind(MOD .. " + M", hl.dsp.window.fullscreen())
hl.bind("F11", hl.dsp.window.fullscreen())

hl.bind(MOD .. " + " .. LMB, hl.dsp.window.drag())
hl.bind(MOD .. " + " .. RMB, hl.dsp.window.resize())
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


-- Media bindings
local raise_volume    = hl.dsp.exec_cmd("noctalia msg volume-up")
local lower_volume    = hl.dsp.exec_cmd("noctalia msg volume-down")
local mute_volume     = hl.dsp.exec_cmd("noctalia msg volume-mute")
local raise_mic       = hl.dsp.exec_cmd("noctalia msg mic-volume-up")
local lower_mic       = hl.dsp.exec_cmd("noctalia msg mic-volume-down")
local mute_mic        = hl.dsp.exec_cmd("noctalia msg mic-mute")
local brightness_up   = hl.dsp.exec_cmd("noctalia msg brightness-up")
local brightness_down = hl.dsp.exec_cmd("noctalia msg brightness-down")
local audio_play      = hl.dsp.exec_cmd("noctalia msg media toggle")
local audio_pause     = hl.dsp.exec_cmd("noctalia msg media toggle")
local audio_stop      = hl.dsp.exec_cmd("noctalia msg media stop")
local audio_next      = hl.dsp.exec_cmd("noctalia msg media next")
local audio_prev      = hl.dsp.exec_cmd("noctalia msg media previous")

hl.bind("XF86AudioRaiseVolume", raise_volume, { repeating = true })
hl.bind("XF86AudioLowerVolume", lower_volume, { repeating = true })
hl.bind("XF86AudioMute", mute_volume)
hl.bind("XF86AudioMicMute", mute_mic)
hl.bind("XF86MonBrightnessUp", brightness_up, { repeating = true })
hl.bind("XF86MonBrightnessDown", brightness_down, { repeating = true })
hl.bind("XF86AudioPlay", audio_play)
hl.bind("XF86AudioPause", audio_pause)
hl.bind("XF86AudioStop", audio_stop)
hl.bind("XF86AudioNext", audio_next)
hl.bind("XF86AudioPrev", audio_prev)

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


-- Application bindings
local terminal = "uwsm app -- kitty"
local text_editor = "uwsm app -- neovide"
local file_manager = "uwsm app -- nautilus"
local browser = "uwsm app -- firefox"
local private_browser = "uwsm app -- firefox --private-window"
local launcher = "noctalia msg panel-toggle launcher"
local clipboard_manager = "noctalia msg panel-toggle clipboard"
local system_menu = "noctalia msg panel-toggle session"
local task_manager = "noctalia msg panel-toggle control-center system"
local lock_screen = "noctalia msg session lock"

hl.bind(MOD .. " + ESCAPE", hl.dsp.exec_cmd(system_menu))
hl.bind(MOD .. " + X", hl.dsp.exec_cmd(lock_screen))
hl.bind(MOD .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(MOD .. " + N", hl.dsp.exec_cmd(text_editor))
hl.bind(MOD .. " + E", hl.dsp.exec_cmd(file_manager))
hl.bind(MOD .. " + R", hl.dsp.exec_cmd(launcher))
hl.bind(MOD .. " + V", hl.dsp.exec_cmd(clipboard_manager))
hl.bind(MOD .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(MOD .. " + SHIFT + B", hl.dsp.exec_cmd(private_browser))
hl.bind(MOD .. " + S", hl.dsp.exec_cmd(task_manager))


-- Screenshot bindings
local screenshot_all = hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen all")
local screenshot_region = hl.dsp.exec_cmd("noctalia msg screenshot-region")

hl.bind(MOD .. " + P", screenshot_all)
hl.bind(MOD .. " + SHIFT + P", screenshot_region)
hl.bind("Print", screenshot_region)


-- Workspace navigation bindings
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(MOD .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(MOD .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(MOD .. " + grave", hl.dsp.workspace.toggle_special("S"))
hl.bind(MOD .. " + period", hl.dsp.focus({ workspace = "+1" }), { repeating = true })
hl.bind(MOD .. " + comma", hl.dsp.focus({ workspace = "-1" }), { repeating = true })

hl.bind(MOD .. " + SHIFT + grave", hl.dsp.window.move({ workspace = "special:S" }))
hl.bind(MOD .. " + SHIFT + period", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })
hl.bind(MOD .. " + SHIFT + comma", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
