local wezterm = require 'wezterm'
local act = wezterm.action

local is_windows = wezterm.target_triple:find("windows") ~= nil

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end
config.automatically_reload_config = true


config.color_scheme = 'Tokyo Night'

-- Font
config.font = wezterm.font(
    "Terminess Nerd Font",
    { weight = "Medium", stretch = "Normal", style = "Normal" }
)
config.font_size = 18
config.cell_width = 1.1
config.line_height = 1.2

-- Window
config.initial_cols = 120
config.initial_rows = 30
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.window_decorations = 'RESIZE'
config.window_background_opacity = 0.90
config.window_frame = {
    inactive_titlebar_bg = "none",
    active_titlebar_bg = "none",
}

-- Tab Bar
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.hide_tab_bar_if_only_one_tab = true
config.show_new_tab_button_in_tab_bar = false
config.tab_bar_at_bottom = true
config.tab_max_width = 16

-- Key Bindings
config.disable_default_key_bindings = true
config.keys = {
    -- Toggle full screen
    {
        key = 'F11',
        action = act.ToggleFullScreen,
    },
    -- Increase/Decrease font size
    {
        key = 'UpArrow',
        mods = 'CTRL|ALT',
        action = act.IncreaseFontSize,
    },
    {
        key = 'DownArrow',
        mods = 'CTRL|ALT',
        action = act.DecreaseFontSize,
    },
    -- Copy/Paste
    {
        key = 'y',
        mods = 'CTRL|ALT',
        action = act.CopyTo 'Clipboard',
    },
    {
        key = 'p',
        mods = 'CTRL|ALT',
        action = act.PasteFrom 'Clipboard',
    },
    -- Copy Mode
    {
        key = 'c',
        mods = 'CTRL|ALT',
        action = act.ActivateCopyMode,
    },
    -- Quit
    {
        key = 'q',
        mods = 'CTRL|ALT',
        action = act.QuitApplication,
    },

    -- New/Close Tab
    {
        key = 'n',
        mods = 'CTRL|ALT',
        action = act.SpawnTab 'CurrentPaneDomain',
    },
    {
        key = 'w',
        mods = 'CTRL|ALT',
        action = act.CloseCurrentTab { confirm = true },
    },
    -- Focus Tab
    {
        key = ']',
        mods = 'CTRL|ALT',
        action = act.ActivateTabRelative(1),
    },
    {
        key = '[',
        mods = 'CTRL|ALT',
        action = act.ActivateTabRelative(-1),
    },
    -- Move Tab
    {
        key = '}',
        mods = 'CTRL|ALT|SHIFT',
        action = act.MoveTabRelative(1),
    },
    -- Move Tab
    {
        key = '{',
        mods = 'CTRL|ALT|SHIFT',
        action = act.MoveTabRelative(-1),
    },

    -- Split Panes
    {
        key = 'v',
        mods = 'CTRL|ALT',
        action = act.SplitHorizontal { domain = 'CurrentPaneDomain' },
    },
    {
        key = 's',
        mods = 'CTRL|ALT',
        action = act.SplitVertical { domain = 'CurrentPaneDomain' },
    },
    -- Close Pane
    {
        key = 'w',
        mods = 'CTRL|ALT',
        action = act.CloseCurrentPane { confirm = true },
    },
    -- Focus Panes
    {
        key = 'j',
        mods = 'CTRL|ALT',
        action = act.ActivatePaneDirection 'Down',
    },
    {
        key = 'k',
        mods = 'CTRL|ALT',
        action = act.ActivatePaneDirection 'Up',
    },
    {
        key = 'h',
        mods = 'CTRL|ALT',
        action = act.ActivatePaneDirection 'Left',
    },
    {
        key = 'l',
        mods = 'CTRL|ALT',
        action = act.ActivatePaneDirection 'Right',
    },
    -- Resize Panes
    {
        key = 'j',
        mods = 'CTRL|ALT|SHIFT',
        action = act.AdjustPaneSize { 'Down', 1 },
    },
    {
        key = 'k',
        mods = 'CTRL|ALT|SHIFT',
        action = act.AdjustPaneSize { 'Up', 1 },
    },
    {
        key = 'h',
        mods = 'CTRL|ALT|SHIFT',
        action = act.AdjustPaneSize { 'Left', 1 },
    },
    {
        key = 'l',
        mods = 'CTRL|ALT|SHIFT',
        action = act.AdjustPaneSize { 'Right', 1 },
    },
    -- Toggle Pane Zoom
    {
        key = 'z',
        mods = 'CTRL|ALT',
        action = act.TogglePaneZoomState,
    },
    -- Rotate Panes
    {
        key = 'r',
        mods = 'CTRL|ALT',
        action = act.RotatePanes 'Clockwise',
    },
}

-- Mouse Bindings
config.disable_default_mouse_bindings = false
config.mouse_bindings = {
    -- Drag window
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL|ALT',
        action = act.StartWindowDrag,
    },
}


if is_windows then
    config.audible_bell = "Disabled"

    config.wsl_domains = {
        {
            name = 'WSL:NixOS',
            distribution = 'NixOS',
            default_cwd = "~",
        },
    }

    config.default_domain = 'WSL:NixOS'
end


return config
