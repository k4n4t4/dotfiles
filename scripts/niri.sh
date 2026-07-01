if cmd_exists niri; then
    dotconf "niri" -r
    if ! [ -f "$TARGET_PATH/.config/niri/noctalia.kdl" ]; then
        msg_run touch "$TARGET_PATH/.config/niri/noctalia.kdl"
    fi
fi
