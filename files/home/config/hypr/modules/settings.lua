hl.monitor {
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1.0",
    transform = 0,
}

hl.config {
    general = {
        border_size = 2,
        gaps_in = 4,
        gaps_out = 10,
        gaps_workspaces = 0,
        layout = "scrolling",
    },
    scrolling = {
        column_width = 1.0,
        focus_fit_method = 0,
        direction = "down",
    },
    input = {
        follow_mouse = 2,
        float_switch_override_focus = 0,
        kb_layout = "us",
        repeat_rate = 50,
        repeat_delay = 250,
        sensitivity = -0.3,
        accel_profile = "flat",
        touchpad = {
            disable_while_typing = true,
            scroll_factor = 1.0,
        },
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.9,
        fullscreen_opacity = 1.0,
        inactive_opacity = 0.8,
        dim_inactive = false,
        blur = {
            enabled = true,
            size = 2,
            passes = 2,
        },
        shadow = { enabled = false },
    },
    animations = {
        enabled = true,
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        focus_on_activate = true,
    },
}

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

hl.window_rule {
    match = {
        float = true
    },
    no_blur = true,
    no_anim = true,
}
