hl.config {
    general = {
        border_size = 2,
        gaps_in = 4,
        gaps_out = 10,
        gaps_workspaces = 0,
        layout = "dwindle",
        resize_corner = 0,
    },
    dwindle = {
        force_split = 2,
    },
    decoration = {
        rounding = 10,
        active_opacity = 0.9,
        fullscreen_opacity = 1.0,
        inactive_opacity = 0.8,
        dim_inactive = false,
        blur = { enabled = true },
    },
    xwayland = { enabled = true },
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
