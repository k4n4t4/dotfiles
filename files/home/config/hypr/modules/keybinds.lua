local MOD = "SUPER"
local LMB = "mouse:272"
local RMB = "mouse:273"


--------------
-- HYPRLAND --
--------------

hl.bind(
    MOD .. " + SHIFT + Q",
    hl.dsp.exec_cmd("uwsm stop"),
    { description = "Stop Hyprland" }
)
hl.bind(
    MOD .. " + SHIFT + R",
    hl.dsp.exec_cmd("hyprctl reload"),
    { description = "Reload Hyprland" }
)


-------------
-- WINDOWS --
-------------

hl.bind(
    MOD .. " + Q",
    function()
        local window = hl.get_active_window()
        if not window then return end

        local browser_classes = {
            "firefox", "chromium", "brave", "vivaldi",
            "opera", "edge", "epiphany", "midori",
            "dillo", "lynx", "links", "w3m"
        }

        local is_browser = false
        for _, class in ipairs(browser_classes) do
            if window.class:lower() == class then
                is_browser = true
                break
            end
        end

        if is_browser then
            hl.dispatch(hl.dsp.window.kill())
        else
            hl.dispatch(hl.dsp.window.close())
        end
    end,
    { description = "Close window" }
)
hl.bind(
    MOD .. " + ALT + Q",
    hl.dsp.window.kill(),
    { description = "Kill window" }
)
hl.bind(
    MOD .. " + F",
    hl.dsp.window.float(),
    { description = "Toggle window floating" }
)
hl.bind(
    MOD .. " + C",
    function()
        local window = hl.get_active_window()
        if not window then return end

        if window.floating then
            hl.dispatch(hl.dsp.window.center())
        end
    end,
    { description = "Center window" }
)
hl.bind(
    MOD .. " + M",
    hl.dsp.window.fullscreen(),
    { description = "Toggle window fullscreen" }
)
hl.bind(
    "F11",
    hl.dsp.window.fullscreen(),
    { description = "Toggle window fullscreen" }
)

hl.bind(
    MOD .. " + " .. LMB,
    hl.dsp.window.drag(),
    { description = "Drag window" }
)
hl.bind(
    MOD .. " + " .. RMB,
    hl.dsp.window.resize(),
    { description = "Resize window" }
)
hl.bind(
    MOD .. " + H",
    hl.dsp.focus({ direction = "l" }),
    { description = "Focus window left" }
)
hl.bind(
    MOD .. " + L",
    hl.dsp.focus({ direction = "r" }),
    { description = "Focus window right" }
)
hl.bind(
    MOD .. " + K",
    hl.dsp.focus({ direction = "u" }),
    { description = "Focus window up" }
)
hl.bind(
    MOD .. " + J",
    hl.dsp.focus({ direction = "d" }),
    { description = "Focus window down" }
)
hl.bind(
    MOD .. " + TAB",
    function()
        hl.dispatch(hl.dsp.window.cycle_next({ next = true }))
        hl.dispatch(hl.dsp.window.bring_to_top())
    end,
    { repeating = true, description = "Cycle window next" }
)
hl.bind(
    MOD .. " + SHIFT + H",
    function()
        local window = hl.get_active_window()
        if not window then return end

        if window.floating then
            hl.dispatch(hl.dsp.window.move({ x = -20, y = 0, relative = true }))
        else
            hl.dispatch(hl.dsp.window.swap({ direction = "l" }))
        end
    end,
    { repeating = true, description = "Swap window left" }
)
hl.bind(
    MOD .. " + SHIFT + L",
    function()
        local window = hl.get_active_window()
        if not window then return end

        if window.floating then
            hl.dispatch(hl.dsp.window.move({ x = 20, y = 0, relative = true }))
        else
            hl.dispatch(hl.dsp.window.swap({ direction = "r" }))
        end
    end,
    { repeating = true, description = "Swap window right" }
)
hl.bind(
    MOD .. " + SHIFT + K",
    function()
        local window = hl.get_active_window()
        if not window then return end

        if window.floating then
            hl.dispatch(hl.dsp.window.move({ x = 0, y = -20, relative = true }))
        else
            hl.dispatch(hl.dsp.window.swap({ direction = "u" }))
        end
    end,
    { repeating = true, description = "Swap window up" }
)
hl.bind(
    MOD .. " + SHIFT + J",
    function()
        local window = hl.get_active_window()
        if not window then return end

        if window.floating then
            hl.dispatch(hl.dsp.window.move({ x = 0, y = 20, relative = true }))
        else
            hl.dispatch(hl.dsp.window.swap({ direction = "d" }))
        end
    end,
    { repeating = true, description = "Swap window down" }
)
hl.bind(
    MOD .. " + CTRL + H",
    hl.dsp.window.move({ direction = "l" }),
    { description = "Move window left" }
)
hl.bind(
    MOD .. " + CTRL + L",
    hl.dsp.window.move({ direction = "r" }),
    { description = "Move window right" }
)
hl.bind(
    MOD .. " + CTRL + K",
    hl.dsp.window.move({ direction = "u" }),
    { description = "Move window up" }
)
hl.bind(
    MOD .. " + CTRL + J",
    hl.dsp.window.move({ direction = "d" }),
    { description = "Move window down" }
)
hl.bind(
    MOD .. " + ALT + H",
    hl.dsp.window.resize({ x = -10, y = 0, relative = true }),
    { repeating = true, description = "Resize window left" }
)
hl.bind(
    MOD .. " + ALT + L",
    hl.dsp.window.resize({ x = 10, y = 0, relative = true }),
    { repeating = true, description = "Resize window right" }
)
hl.bind(
    MOD .. " + ALT + K",
    hl.dsp.window.resize({ x = 0, y = -10, relative = true }),
    { repeating = true, description = "Resize window up" }
)
hl.bind(
    MOD .. " + ALT + J",
    hl.dsp.window.resize({ x = 0, y = 10, relative = true }),
    { repeating = true, description = "Resize window down" }
)


-----------
-- MEDIA --
-----------

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

hl.bind(
    "XF86AudioRaiseVolume",
    raise_volume,
    { repeating = true, description = "Raise volume" }
)
hl.bind(
    "XF86AudioLowerVolume",
    lower_volume,
    { repeating = true, description = "Lower volume" }
)
hl.bind(
    "XF86AudioMute",
    mute_volume,
    { description = "Mute volume" }
)
hl.bind(
    "XF86AudioMicMute",
    mute_mic,
    { description = "Mute microphone" }
)
hl.bind(
    "XF86MonBrightnessUp",
    brightness_up,
    { repeating = true, description = "Increase brightness" }
)
hl.bind(
    "XF86MonBrightnessDown",
    brightness_down,
    { repeating = true, description = "Decrease brightness" }
)
hl.bind(
    "XF86AudioPlay",
    audio_play,
    { description = "Play/Pause media" }
)
hl.bind(
    "XF86AudioPause",
    audio_pause,
    { description = "Play/Pause media" }
)
hl.bind(
    "XF86AudioStop",
    audio_stop,
    { description = "Stop media" }
)
hl.bind(
    "XF86AudioNext",
    audio_next,
    { description = "Next media track" }
)
hl.bind(
    "XF86AudioPrev",
    audio_prev,
    { description = "Previous media track" }
)

hl.bind(
    MOD .. " + A",
    hl.dsp.submap("Media"),
    { description = "Media controls" }
)
hl.define_submap("Media", function()
    hl.bind(
        "escape",
        hl.dsp.submap("reset"),
        { description = "Exit media controls" }
    )

    hl.bind(
        "up",
        raise_volume,
        { repeating = true, description = "Raise volume" }
    )
    hl.bind(
        "k",
        raise_volume,
        { repeating = true, description = "Raise volume" }
    )
    hl.bind(
        "down",
        lower_volume,
        { repeating = true, description = "Lower volume" }
    )
    hl.bind(
        "j",
        lower_volume,
        { repeating = true, description = "Lower volume" }
    )
    hl.bind(
        "return",
        mute_volume,
        { description = "Mute volume" }
    )
    hl.bind(
        "SHIFT + k",
        raise_mic,
        { repeating = true, description = "Raise microphone volume" }
    )
    hl.bind(
        "SHIFT + j",
        lower_mic,
        { repeating = true, description = "Lower microphone volume" }
    )
    hl.bind(
        "SHIFT + return",
        mute_mic,
        { description = "Mute microphone" }
    )
    hl.bind(
        "CTRL + k",
        brightness_up,
        { repeating = true, description = "Increase brightness" }
    )
    hl.bind(
        "CTRL + j",
        brightness_down,
        { repeating = true, description = "Decrease brightness" }
    )
end)


------------------
-- APPLICATIONS --
------------------

local terminal = "uwsm app -- kitty"
local file_manager = "uwsm app -- nautilus"
local browser = "uwsm app -- firefox"
local private_browser = "uwsm app -- firefox --private-window"
local launcher = "noctalia msg panel-toggle launcher"
local clipboard_manager = "noctalia msg panel-toggle clipboard"
local system_menu = "noctalia msg panel-toggle session"
local task_manager = "noctalia msg panel-toggle control-center system"
local lock_screen = "noctalia msg session lock"

hl.bind(
    MOD .. " + ESCAPE",
    hl.dsp.exec_cmd(system_menu),
    { description = "Open system menu" }
)
hl.bind(
    MOD .. " + X",
    hl.dsp.exec_cmd(lock_screen),
    { description = "Lock screen" }
)
hl.bind(
    MOD .. " + T",
    hl.dsp.exec_cmd(terminal),
    { description = "Open terminal" }
)
hl.bind(
    MOD .. " + E",
    hl.dsp.exec_cmd(file_manager),
    { description = "Open file manager" }
)
hl.bind(
    MOD .. " + R",
    hl.dsp.exec_cmd(launcher),
    { description = "Open application launcher" }
)
hl.bind(
    MOD .. " + V",
    hl.dsp.exec_cmd(clipboard_manager),
    { description = "Open clipboard manager" }
)
hl.bind(
    MOD .. " + B",
    hl.dsp.exec_cmd(browser),
    { description = "Open browser" }
)
hl.bind(
    MOD .. " + SHIFT + B",
    hl.dsp.exec_cmd(private_browser),
    { description = "Open private browser" }
)
hl.bind(
    MOD .. " + W",
    hl.dsp.exec_cmd(task_manager),
    { description = "Open task manager" }
)


----------------
-- SCREENSHOT --
----------------

local screenshot_all = hl.dsp.exec_cmd("noctalia msg screenshot-fullscreen all")
local screenshot_region = hl.dsp.exec_cmd("noctalia msg screenshot-region")

hl.bind(
    MOD .. " + P",
    screenshot_all,
    { description = "Take screenshot of entire screen" }
)
hl.bind(
    MOD .. " + SHIFT + P",
    screenshot_region,
    { description = "Take screenshot of selected region" }
)
hl.bind(
    "Print",
    screenshot_region,
    { description = "Take screenshot of selected region" }
)


---------------
-- WORKSPACE --
---------------

-- Workspace navigation bindings
for i = 1, 10 do
    local key = tostring(i % 10)
    hl.bind(
        MOD .. " + " .. key,
        hl.dsp.focus({ workspace = i }),
        { description = "Focus workspace " .. i }
    )
    hl.bind(
        MOD .. " + SHIFT + " .. key,
        hl.dsp.window.move({ workspace = i }),
        { description = "Move window to workspace " .. i }
    )
end

hl.bind(
    MOD .. " + mouse_down",
    hl.dsp.focus({ workspace = "e+1" }),
    { description = "Cycle workspace next" }
)
hl.bind(
    MOD .. " + mouse_up",
    hl.dsp.focus({ workspace = "e-1" }),
    { description = "Cycle workspace previous" }
)
hl.bind(
    MOD .. " + bracketright",
    hl.dsp.focus({ workspace = "+1" }),
    { repeating = true, description = "Focus next workspace" }
)
hl.bind(
    MOD .. " + SHIFT + bracketright",
    hl.dsp.window.move({ workspace = "+1" }),
    { repeating = true, description = "Move window to next workspace" }
)
hl.bind(
    MOD .. " + bracketleft",
    hl.dsp.focus({ workspace = "-1" }),
    { repeating = true, description = "Focus previous workspace" }
)
hl.bind(
    MOD .. " + SHIFT + bracketleft",
    hl.dsp.window.move({ workspace = "-1" }),
    { repeating = true, description = "Move window to previous workspace" }
)

-- Special workspace
hl.window_rule {
    match = { workspace = "special:Special" },
    no_blur = true,
}
hl.bind(
    MOD .. " + S",
    hl.dsp.workspace.toggle_special("Special"),
    { description = "Toggle special workspace" }
)
hl.bind(
    MOD .. " + SHIFT + S",
    hl.dsp.window.move({ workspace = "special:Special" }),
    { description = "Move window to special workspace" }
)

local function makeScratchpadToggle(cmd, wsName)
    return function()
        if #(hl.get_windows({ workspace = "special:" .. wsName })) > 0 then
            hl.dispatch(hl.dsp.workspace.toggle_special(wsName))
        else
            hl.exec_cmd(cmd, { workspace = "special:" .. wsName })
        end
    end
end

-- Terminal scratchpad
hl.window_rule {
    match = { workspace = "special:Terminal" },
    no_blur = true,
}
hl.bind(
    MOD .. " + return",
    makeScratchpadToggle(terminal, "Terminal"),
    { description = "Toggle terminal scratchpad" }
)
hl.bind(
    MOD .. " + SHIFT + return",
    hl.dsp.window.move({ workspace = "special:Terminal" }),
    { description = "Move window to terminal scratchpad" }
)
