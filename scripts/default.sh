alias dothome="dot --origin-suffix=home"
alias dotconf="dot --origin-suffix=home/.config --target-suffix=.config"

dot "$WORK_PATH/dm" "bin/dm"
dothome "bin" -r
dothome ".fonts.conf"
dothome ".profile"

if cmd_exists bash; then
  dothome ".bashrc"
fi

if cmd_exists zsh; then
  dothome ".zshrc"
fi

if cmd_exists fish; then
  dotconf "fish" -r
fi

if cmd_exists nu; then
  dotconf "nushell" -r
fi

if cmd_exists vim; then
  dothome ".vimrc"
fi

if cmd_exists nvim; then
  dotconf "nvim" -r -d1
fi

if cmd_exists tmux; then
  dotconf "tmux" -r -i "tmux.conf"
  dothome ".config/tmux/tmux.conf" ".tmux.conf"
fi

if cmd_exists starship; then
  dotconf "starship/starship.toml" "starship.toml"
fi

if cmd_exists Hyprland; then
  dotconf "hypr" -r
fi

if cmd_exists wofi; then
  dotconf "wofi" -r
fi

if cmd_exists ags; then
  if [ ! -d "$DOT_TARGET_PATH/.config/ags/@girs" ]; then
    msg_run ags init --directory "$DOT_TARGET_PATH/.config/ags" --force
    msg_run rm "$DOT_TARGET_PATH/.config/ags/app.ts"
    msg_run rm "$DOT_TARGET_PATH/.config/ags/style.scss"
    msg_run rm "$DOT_TARGET_PATH/.config/ags/widget/Bar.tsx"
    msg_run rmdir "$DOT_TARGET_PATH/.config/ags/widget"
  fi
  dotconf "ags" -r
fi

if cmd_exists fastfetch; then
  dotconf "fastfetch" -r
fi

if cmd_exists kitty; then
  dotconf "kitty" -r
fi

if cmd_exists sheldon; then
  dotconf "sheldon" -r
fi

if cmd_exists eza; then
  dotconf "eza" -r
fi

if cmd_exists wlogout; then
  dotconf "wlogout" -r
fi

if cmd_exists firefox; then
  for folder in ~/.mozilla/firefox/*.default-release; do
    if [ -d "$folder" ]; then
      dothome ".config/firefox/user.js" "$folder/user.js"
      dothome ".config/firefox/userChrome.css" "$folder/chrome/userChrome.css"
      dothome ".config/firefox/userContent.css" "$folder/chrome/userContent.css"
    fi
  done
fi
