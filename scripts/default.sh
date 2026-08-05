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
    dotconf "noctalia/config.toml" -ct
fi
