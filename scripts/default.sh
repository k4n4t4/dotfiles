alias dothome="dot --origin-suffix=home"
alias dotconf="dot --origin-suffix=home/.config --target-suffix=.config"

dot "$WORK_PATH/dm" "bin/dm"
dothome "bin" -r
dothome ".fonts.conf"
dothome ".profile"

if cmd_exist bash; then
  dothome ".bashrc"
fi

if cmd_exist zsh; then
  dothome ".zshrc"
fi

if cmd_exist fish; then
  dotconf "fish" -r
fi

if cmd_exist nu; then
  dotconf "nushell" -r
fi

if cmd_exist vim; then
  dothome ".vimrc"
fi

if cmd_exist nvim; then
  dotconf "nvim" -r -d1
fi

if cmd_exist tmux; then
  dotconf "tmux" -r -i "tmux.conf"
  dothome ".config/tmux/tmux.conf" ".tmux.conf"
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
  if [ ! -d "$DOT_TARGET_PATH/.config/ags/@girs" ]; then
    msg_run ags init --directory "$DOT_TARGET_PATH/.config/ags" --force
    msg_run rm "$DOT_TARGET_PATH/.config/ags/app.ts"
    msg_run rm "$DOT_TARGET_PATH/.config/ags/style.scss"
    msg_run rm "$DOT_TARGET_PATH/.config/ags/widget/Bar.tsx"
    msg_run rmdir "$DOT_TARGET_PATH/.config/ags/widget"
  fi
  dotconf "ags" -r
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
