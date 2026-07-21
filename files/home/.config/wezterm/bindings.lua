local wezterm = require 'wezterm'
local act = wezterm.action

local M = {}

M.key = {
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
    {
        key = '.',
        mods = 'CTRL|ALT',
        action = act.ActivatePaneDirection 'Next',
    },
    {
        key = ',',
        mods = 'CTRL|ALT',
        action = act.ActivatePaneDirection 'Prev',
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

    -- Show Debug Overlay
    {
        key = 'F12',
        action = wezterm.action.ShowDebugOverlay,
    },
}

M.mouse = {
    {
        event = { Down = { streak = 1, button = 'Right' } },
        mods = 'CTRL',
        action = act.PasteFrom 'Clipboard',
    },
    {
        event = { Drag = { streak = 1, button = 'Left' } },
        mods = 'CTRL|ALT',
        action = wezterm.action.StartWindowDrag,
    },
}

return M
