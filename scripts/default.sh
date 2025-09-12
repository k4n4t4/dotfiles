alias dotconf="dot --origin-suffix=.config --target-suffix=.config"

dot "$WORK_PATH/dm" "bin/dm"
dot "bin" -r
dot ".fonts.conf"
dot ".profile"

if cmd_exist bash; then
  dot ".bashrc"
fi

if cmd_exist zsh; then
  dot ".zshrc"
fi

if cmd_exist fish; then
  dotconf "fish" -r
fi

if cmd_exist nu; then
  dotconf "nushell" -r
fi

if cmd_exist vim; then
  dot ".vimrc"
fi

if cmd_exist nvim; then
  dotconf "nvim" -r -d1
fi

if cmd_exist tmux; then
  dotconf "tmux" -r -i "tmux.conf"
  dot ".config/tmux/tmux.conf" ".tmux.conf"
fi

if cmd_exist starship; then
  dotconf "starship/starship.toml" "starship.toml"
fi

if cmd_exist Hyprland; then
  dotconf "hypr" -r
fi

if cmd_exist wofi; then
  dotconf "wofi" -r
fi

if cmd_exist ags; then
  dotconf "ags" -r
  if [ ! -d "$DOT_TARGET_PATH/.config/ags/@girs" ]; then
    msg_log "run: ags types -d \"$DOT_TARGET_PATH/.config/ags\" -p"
    ags types -d "$DOT_TARGET_PATH/.config/ags" -p
    msg_log "run: npm install --prefix=\"$DOT_TARGET_PATH/.config/ags\" typescript@5.7.3"
    npm install --prefix="$DOT_TARGET_PATH/.config/ags" typescript@5.7.3
  fi
fi

if cmd_exist fastfetch; then
  dotconf "fastfetch" -r
fi

if cmd_exist kitty; then
  dotconf "kitty" -r
fi

if cmd_exist sheldon; then
  dotconf "sheldon" -r
fi

if cmd_exist eza; then
  dotconf "eza" -r
fi

if cmd_exist wlogout; then
  dotconf "wlogout" -r
fi

if cmd_exist firefox; then
  source_script sub/firefox
fi

if cmd_exist git; then
  source_script sub/git
fi
