local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}
if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.automatically_reload_config = true

config.color_scheme = 'Tokyo Night'

-- Font
config.font = wezterm.font(
    "ComicShannsMono Nerd Font",
    { weight = "Medium", stretch = "Normal", style = "Normal" }
)
config.font_size = 13

-- Window
config.initial_cols = 120
config.initial_rows = 30
config.window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
}
config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true
config.window_background_opacity = 0.85


-- Key Bindings
config.disable_default_key_bindings = true
config.keys = {
    -- Toggle full screen
    {
        key = 'F11',
        mods = '',
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
        key = 'c',
        mods = 'CTRL|ALT',
        action = act.CopyTo 'Clipboard',
    },
    {
        key = 'v',
        mods = 'CTRL|ALT',
        action = act.PasteFrom 'Clipboard',
    },

    -- Pager
    {
        key = 'p',
        mods = 'CTRL|ALT',
        action = act.ActivateCopyMode,
    },

    -- Quit
    {
        key = 'q',
        mods = 'CTRL|ALT',
        action = act.QuitApplication,
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

return config
