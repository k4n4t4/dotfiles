if cmd_exists niri; then
    dotconf "niri" -r
    if ! [ -f "$TARGET_DIR/.config/niri/noctalia.kdl" ]; then
        _print_run touch "$TARGET_DIR/.config/niri/noctalia.kdl"
    fi
fi
