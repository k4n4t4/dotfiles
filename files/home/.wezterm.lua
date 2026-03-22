local wezterm = require 'wezterm'
local act = wezterm.action

local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end


config.color_scheme = 'Tokyo Night'

config.window_background_opacity = 0.85

config.font = wezterm.font("ComicShannsMono Nerd Font", { weight = "Medium", stretch = "Normal", style = "Normal" })

config.font_size = 14

config.window_decorations = "RESIZE"
config.hide_tab_bar_if_only_one_tab = true

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

config.mouse_bindings = {
    -- Drag window
    {
        event = { Down = { streak = 1, button = 'Left' } },
        mods = 'CTRL|ALT',
        action = act.StartWindowDrag,
    },
}

return config
