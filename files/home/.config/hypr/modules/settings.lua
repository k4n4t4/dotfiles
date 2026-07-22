hl.config {
    general = {
        border_size = 2,
        gaps_in = 4,
        gaps_out = 10,
        gaps_workspaces = 0,
        layout = "scrolling",
    },
    scrolling = {
        column_width = 0.75,
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.9,
        fullscreen_opacity = 1.0,
        inactive_opacity = 0.8,
        dim_inactive = false,
        blur = { enabled = true },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
    },
    input = {
        kb_layout = "us",
        repeat_rate = 50,
        repeat_delay = 250,
        sensitivity = -0.6,
        touchpad = {
            disable_while_typing = true,
            scroll_factor = 1.0,
        },
    },
    animations = {
        enabled = true,
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
