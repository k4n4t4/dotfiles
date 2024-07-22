local wezterm = require("wezterm")
local action  = wezterm.action
local config  = {}

-- color --
config.color_scheme = "Tokyo Night"
config.force_reverse_video_cursor = true
config.colors = {
  foreground = 'silver',
  background = 'black',
  cursor_bg = 'silver',
  cursor_fg = 'black',
  cursor_border = 'silver',
  ansi = {
    'black',
    'maroon',
    'green',
    'olive',
    'navy',
    'purple',
    'teal',
    'silver',
  },
  brights = {
    'grey',
    'red',
    'lime',
    'yellow',
    'blue',
    'fuchsia',
    'aqua',
    'white',
  },
}
config.text_background_opacity = 0.95
config.window_background_opacity = 0.9

-- font --
config.font = wezterm.font(
  "ComicShannsMono Nerd Font Mono",
  {
    weight  = "Medium",
    stretch = "Normal",
    style   = "Normal"
  }
)
config.font_size = 15

-- ui --
config.window_decorations = "NONE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 4000
config.window_padding = {
  left   = 0,
  right  = 0,
  top    = 0,
  bottom = 0
}
config.enable_scroll_bar = false

config.use_fancy_tab_bar = false
config.enable_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

config.default_cursor_style = 'SteadyBlock'

-- key --
config.keys = {
  {
    key = "F11",
    mods = "",
    action = action.ToggleFullScreen
  }
}

config.default_prog = {
  "/home/linuxbrew/.linuxbrew/bin/fish"
}

return config
