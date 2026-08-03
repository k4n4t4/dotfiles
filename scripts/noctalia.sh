if cmd_exists noctalia; then
    dotconf "noctalia" -r
    if ! [ -d "$TARGET_DIR/pers/media/images/wallpapers" ]; then
        _print_run mkdir -p "$TARGET_DIR/pers/media/images/wallpapers"
    fi
    if ! [ -f "$TARGET_DIR/pers/media/images/wallpapers/wallpaper.png" ]; then
        _print_run cp "$FILES_DIR/assets/wallpaper.png" "$TARGET_DIR/pers/media/images/wallpapers"
    fi
fi
