dot "$WORK_DIR/dm" ".local/bin/dm"

dothome "bin" ".local/bin" -r
dothome ".profile"
dotconf "fontconfig" -r

if cmd_exists bash; then
    dothome ".bashrc"
fi

if cmd_exists fish; then
    dotconf "fish" -r
fi

if cmd_exists vim; then
    dotconf "vim" -r
fi

if cmd_exists nvim; then
    dotconf "nvim" -r -d1
fi

if cmd_exists tmux; then
    dotconf "tmux" -r
fi

if cmd_exists starship; then
    dotconf "starship/starship.toml" "starship.toml"
fi

if cmd_exists hyprland; then
    dotconf "hypr" -r
fi

if cmd_exists fcitx5; then
    dotconf "fcitx5" -r
fi

if cmd_exists mpv; then
    dotconf "mpv" -r
fi

if cmd_exists fastfetch; then
    dotconf "fastfetch" -r
fi

if cmd_exists kitty; then
    dotconf "kitty" -r
fi

if cmd_exists eza; then
    dotconf "eza" -r
fi

if cmd_exists navi; then
    dotconf "navi" -r
fi

if cmd_exists noctalia; then
    dotconf "noctalia" -r
fi


dothome "config/xdg/user-dirs.dirs" ".config/user-dirs.dirs"
# shellcheck disable=SC1091
. "$TARGET_DIR/.config/user-dirs.dirs"
! [ -d "$XDG_DESKTOP_DIR" ]     && _print_run mkdir -p -- "$XDG_DESKTOP_DIR"
! [ -d "$XDG_DOWNLOAD_DIR" ]    && _print_run mkdir -p -- "$XDG_DOWNLOAD_DIR"
! [ -d "$XDG_TEMPLATES_DIR" ]   && _print_run mkdir -p -- "$XDG_TEMPLATES_DIR"
! [ -d "$XDG_PUBLICSHARE_DIR" ] && _print_run mkdir -p -- "$XDG_PUBLICSHARE_DIR"
! [ -d "$XDG_DOCUMENTS_DIR" ]   && _print_run mkdir -p -- "$XDG_DOCUMENTS_DIR"
! [ -d "$XDG_MUSIC_DIR" ]       && _print_run mkdir -p -- "$XDG_MUSIC_DIR"
! [ -d "$XDG_PICTURES_DIR" ]    && _print_run mkdir -p -- "$XDG_PICTURES_DIR"
! [ -d "$XDG_VIDEOS_DIR" ]      && _print_run mkdir -p -- "$XDG_VIDEOS_DIR"
! [ -d "$XDG_PROJECTS_DIR" ]    && _print_run mkdir -p -- "$XDG_PROJECTS_DIR"
xdg-user-dirs-update

if ! [ -d "$TARGET_DIR/pers/media/images/wallpapers" ]; then
    _print_run mkdir -p "$TARGET_DIR/pers/media/images/wallpapers"
fi
if ! [ -f "$TARGET_DIR/pers/media/images/wallpapers/wallpaper.png" ]; then
    _print_run cp "$FILES_DIR/assets/wallpaper.png" "$TARGET_DIR/pers/media/images/wallpapers"
fi
