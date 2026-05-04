hl.config({
    general = {
        border_size = 1,
        gaps_in = 0,
        gaps_out = 0,
        gaps_workspaces = 0,
        col = {
            active_border = "rgba(907020ee)",
            inactive_border = "rgba(292999a0)",
            nogroup_border = "rgba(ffffaaff)",
            nogroup_border_active = "rgba(ffffaaff)",
        },
        layout = "dwindle",
        no_focus_fallback = false,
        hover_icon_on_border = true,
        resize_on_border = false,
        extend_border_grab_area = 15,
        allow_tearing = false,
        resize_corner = 0,
    },
    decoration = {
        rounding = 0,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        fullscreen_opacity = 1.0,
        dim_inactive = false,
        dim_strength = 0.3,
        dim_special = 0.3,
        dim_around = 0.4,
        screen_shader = "",
        blur = {
            enabled = false,
            size = 8,
            passes = 1,
            ignore_opacity = false,
            new_optimizations = true,
            xray = false,
            noise = 0.0117,
            contrast = 0.9,
            brightness = 0.9,
            vibrancy = 0.1696,
            vibrancy_darkness = 0.0,
            special = true,
            popups = true,
            popups_ignorealpha = 0.2,
        },
    },
    xwayland = {
        enabled = true,
        use_nearest_neighbor = true,
        force_zero_scaling = true,
    },
    render = {
        direct_scanout = false,
    },
    opengl = {
        nvidia_anti_flicker = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        col = {
            splash = "0xffffff",
        },
        font_family = "Sans",
        splash_font_family = "[[Empty]]",
        force_default_wallpaper = -1,
        vrr = 0,
        mouse_move_enables_dpms = false,
        key_press_enables_dpms = false,
        always_follow_on_dnd = true,
        layers_hog_keyboard_focus = true,
        animate_manual_resizes = false,
        animate_mouse_windowdragging = false,
        disable_autoreload = true,
        enable_swallow = false,
        swallow_regex = "[[Empty]]",
        swallow_exception_regex = "[[Empty]]",
        focus_on_activate = false,
        mouse_move_focuses_monitor = true,
        allow_session_lock_restore = false,
        background_color = "0x111111",
        close_special_on_empty = true,
        exit_window_retains_fullscreen = false,
        initial_workspace_tracking = 1,
        middle_click_paste = true,
    },
    input = {
        kb_model = "",
        kb_layout = "us",
        kb_variant = "",
        kb_options = "",
        kb_rules = "",
        kb_file = "",
        numlock_by_default = false,
        resolve_binds_by_sym = false,
        repeat_rate = 50,
        repeat_delay = 250,
        sensitivity = 0.6,
        accel_profile = "raw",
        force_no_accel = false,
        left_handed = false,
        scroll_points = "",
        scroll_method = "",
        scroll_button = 0,
        scroll_button_lock = false,
        scroll_factor = 1.0,
        natural_scroll = false,
        follow_mouse = 2,
        mouse_refocus = true,
        float_switch_override_focus = 1,
        special_fallthrough = false,
        off_window_axis_events = 1,
        emulate_discrete_scroll = 1,
        touchpad = {
            disable_while_typing = true,
            natural_scroll = false,
            scroll_factor = 1.0,
            middle_button_emulation = false,
            tap_button_map = "[[Empty]]",
            clickfinger_behavior = false,
            tap_to_click = true,
            drag_lock = false,
            tap_and_drag = false,
        },
        touchdevice = {
            transform = 0,
            output = "[[Auto]]",
            enabled = true,
        },
        tablet = {
            transform = 0,
            output = "[[Empty]]",
            region_position = { 0, 0 },
            region_size = { 0, 0 },
            relative_input = false,
            left_handed = false,
            active_area_size = { 0, 0 },
            active_area_position = { 0, 0 },
        },
    },
    group = {
        insert_after_current = true,
        focus_removed_window = true,
        col = {
            border_active = "rgba(66ffff00)",
            border_inactive = "rgba(66777700)",
            border_locked_active = "rgba(66ff5500)",
            border_locked_inactive = "rgba(66775500)",
        },
        groupbar = {
            enabled = true,
            font_family = "[[Empty]]",
            font_size = 8,
            gradients = true,
            height = 14,
            stacked = false,
            priority = 3,
            render_titles = true,
            scrolling = true,
            text_color = "rgba(ffffffff)",
            col = {
                active = "rgba(66ffff00)",
                inactive = "rgba(66777700)",
                locked_active = "rgba(66ff5500)",
                locked_inactive = "rgba(66775500)",
            },
        },
    },
    gestures = {
        workspace_swipe_distance = 300,
        workspace_swipe_touch = false,
        workspace_swipe_invert = true,
        workspace_swipe_touch_invert = false,
        workspace_swipe_min_speed_to_force = 30,
        workspace_swipe_cancel_ratio = 0.5,
        workspace_swipe_create_new = true,
        workspace_swipe_direction_lock = true,
        workspace_swipe_direction_lock_threshold = 10,
        workspace_swipe_forever = false,
        workspace_swipe_use_r = false,
    },
    dwindle = {
        preserve_split = true,
        force_split = 2,
        smart_split = false,
        smart_resizing = true,
        permanent_direction_override = false,
        special_scale_factor = 1.0,
        split_width_multiplier = 1.0,
        use_active_for_splits = true,
        default_split_ratio = 1.0,
        split_bias = 0,
    },
    master = {
        allow_small_split = false,
        special_scale_factor = 1.0,
        mfact = 0.5,
        new_status = "slave",
        new_on_top = false,
        new_on_active = "none",
        orientation = "left",
        smart_resizing = true,
        drop_at_cursor = true,
    },
    cursor = {
        no_hardware_cursors = false,
        no_break_fs_vrr = false,
        min_refresh_rate = 24,
        hotspot_padding = 1,
        inactive_timeout = 0,
        no_warps = false,
        persistent_warps = false,
        warp_on_change_workspace = false,
        default_monitor = "[[Empty]]",
        zoom_factor = 1.0,
        zoom_rigid = false,
        enable_hyprcursor = true,
        hide_on_key_press = false,
        hide_on_touch = true,
    },
    binds = {
        pass_mouse_when_bound = false,
        scroll_event_delay = 300,
        workspace_back_and_forth = false,
        allow_workspace_cycles = false,
        workspace_center_on = 0,
        focus_preferred_method = 0,
        ignore_group_lock = false,
        movefocus_cycles_fullscreen = true,
        disable_keybind_grabbing = false,
        window_direction_monitor_fallback = true,
    },
    animations = {
        enabled = true,
    },
})

hl.curve("linear", { type = "bezier", points = { { 0.0, 0.0 }, { 1.0, 1.0 } } })
hl.curve("ease-out-quint", { type = "bezier", points = { { 0.22, 1.0 }, { 0.36, 1.0 } } })
hl.curve("ease-out-back", { type = "bezier", points = { { 0.34, 1.56 }, { 0.64, 1.0 } } })
hl.curve("ease-in-out-cubic", { type = "bezier", points = { { 0.65, 0.0 }, { 0.35, 1.0 } } })
hl.curve("ease-in-out-circ", { type = "bezier", points = { { 0.85, 0.0 }, { 0.15, 1.0 } } })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3, bezier = "ease-out-back" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "linear" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "ease-in-out-circ" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "ease-in-out-cubic" })
hl.animation({ leaf = "fade", enabled = true, speed = 5, bezier = "default" })

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1.0",
    transform = 0,
})

for i = 1, 10 do
    hl.workspace_rule({ workspace = tostring(i), persistent = false })
end

hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11,*")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("SDL_VIDEODRIVER", "wayland")
hl.env("CLUTTER_BACKEND", "wayland")
hl.env("XDG_SCALE", "1")
hl.env("GDK_SCALE", "1")
hl.env("XCURSOR_SIZE", "12")
hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
hl.env("NVD_BACKEND", "direct")
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")

hl.on("hyprland.start", function()
    -- fcitx5
    hl.exec_cmd("uwsm app -- fcitx5 -d")

    -- waybar
    hl.exec_cmd("uwsm app -- waybar")

    -- awww
    hl.exec_cmd("uwsm app -- awww-daemon")
    hl.exec_cmd("uwsm app -- awww img ~/pers/imgs/wallpaper.png --transition-type center --transition-duration 1")

    -- mako
    hl.exec_cmd("uwsm app -- mako")

    -- swayosd
    hl.exec_cmd("uwsm app -- swayosd-server")

    -- polkit
    hl.exec_cmd("uwsm app -- /usr/lib/mate-polkit/polkit-mate-authentication-agent-1")

    -- wl-clipboard
    hl.exec_cmd("uwsm app -- wl-paste -w cliphist store")

    -- hypridle
    hl.exec_cmd("pidof hypridle || uwsm app -- hypridle")
end)

local MOD = "SUPER"
local LMB = "mouse:272"
local RMB = "mouse:273"

local function noop() end

hl.bind(MOD .. " + SHIFT + Q", hl.dsp.exit())
hl.bind(MOD .. " + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))

hl.bind(MOD .. " + O", hl.dsp.exec_cmd("hyprshot -m output -o ~/tmp/"))
hl.bind(MOD .. " + CTRL + O", hl.dsp.exec_cmd("hyprshot -m region -o ~/tmp/"))
hl.bind("Print", hl.dsp.exec_cmd("hyprshot -m region -o ~/tmp/"))
hl.bind(MOD .. " + SHIFT + O", hl.dsp.exec_cmd("hyprshot -m window -o ~/tmp/"))
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
    hl.bind("shift_l", noop)
    hl.bind("control_l", noop)
    hl.bind("alt_l", noop)

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
    hl.bind("catchall", hl.dsp.submap("reset"))
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
    hl.bind("shift_l", noop)
    hl.bind("control_l", noop)

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

    hl.bind("catchall", hl.dsp.submap("reset"))
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
