if cmd_exists xdg-user-dirs-update; then
    dothome "config/xdg/user-dirs.dirs" ".config/user-dirs.dirs"

    # shellcheck disable=SC1091
    . "$TARGET_DIR/.config/user-dirs.dirs"
    for dir in \
        "$XDG_DESKTOP_DIR" \
        "$XDG_DOWNLOAD_DIR" \
        "$XDG_TEMPLATES_DIR" \
        "$XDG_PUBLICSHARE_DIR" \
        "$XDG_DOCUMENTS_DIR" \
        "$XDG_MUSIC_DIR" \
        "$XDG_PICTURES_DIR" \
        "$XDG_VIDEOS_DIR" \
        "$XDG_PROJECTS_DIR"
    do
        if ! [ -d "$dir" ]; then
            _print_run mkdir -p -- "$dir"
        fi
    done
    xdg-user-dirs-update

    dot -c assets/wallpaper.png "$XDG_PICTURES_DIR/wallpapers/wallpaper.png"
fi
