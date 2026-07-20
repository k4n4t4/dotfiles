local wezterm = require 'wezterm'

local is_windows = wezterm.target_triple:find("windows") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil
local is_macos = wezterm.target_triple:find("darwin") ~= nil

local config = {}
if wezterm.config_builder then
    config = wezterm.config_builder()
end
config.automatically_reload_config = true

-- Color Scheme
config.color_scheme = 'Tokyo Night'

-- Font
config.font = wezterm.font(
    "Terminess Nerd Font Mono",
    { weight = "Medium", stretch = "Normal", style = "Normal" }
)
config.font_size = 18
config.cell_width = 1.0
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
config.window_background_opacity = 0.30
config.text_background_opacity = 0.80
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

-- Bindings
config.disable_default_key_bindings = true
config.disable_default_mouse_bindings = false
config.keys = require("bindings").key
config.mouse_bindings = require("bindings").mouse

if is_windows then
    config.audible_bell = "Disabled"
    config.wsl_domains = {
        {
            name = 'WSL:archlinux',
            distribution = 'ArchLinux',
            default_cwd = "~",
        },
    }
    config.default_domain = 'WSL:archlinux'
elseif is_linux or is_macos then
    config.default_prog = { "fish", "--login" }

    config.enable_wayland = false
end


return config
