if cmd_exists noctalia; then
    dotconf "noctalia" -r
    if ! [ -d "$TARGET_PATH/pers/media/images/wallpapers" ]; then
        msg_run mkdir -p "$TARGET_PATH/pers/media/images/wallpapers"
    fi
    if ! [ -f "$TARGET_PATH/pers/media/images/wallpapers/wallpaper.png" ]; then
        msg_run cp "$DOTFILES_PATH/assets/wallpaper.png" "$TARGET_PATH/pers/media/images/wallpapers"
    fi
fi
