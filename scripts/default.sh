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
if cmd_exist vim; then
  dot ".vimrc"
fi
if cmd_exist nvim; then
  dotconf "nvim" -r -d1
fi
if cmd_exist tmux; then
  dotconf "tmux" -r -i ".tmux.conf"
  dot ".config/tmux/.tmux.conf" ".tmux.conf"
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
  for folder in ~/.mozilla/firefox/*.default-release; do
    if [ -e "$folder" ]; then
      dot "firefox/user.js" "$folder/user.js"
      dot "firefox/userChrome.css" "$folder/chrome/userChrome.css"
      dot "firefox/userContent.css" "$folder/chrome/userContent.css"
    fi
  done
fi

if cmd_exist git; then
  case "$SUBCOMMAND" in
    ( "install" )
      msg_info "git config"
      msg_ask "  Continue? [Y/n]: "
      case "$RET" in
        ( [nN] ) : ;;
        ( * )
          msg_info "  git config user"
          msg_ask "  Continue? [Y/n]: "
          case "$RET" in
            ( [nN] ) : ;;
            ( * )
              msg_ask "    email: "
              if [ "$RET" != "" ]; then
                git config --global user.email "$RET"
              fi
              msg_ask "    name: "
              if [ "$RET" != "" ]; then
                git config --global user.name "$RET"
              fi
              ;;
          esac
          if cmd_exist delta; then
            msg_info "  git config delta"
            msg_ask "  Continue? [Y/n]: "
            case "$RET" in
              ( [nN] ) : ;;
              ( * )
                git config --global core.pager "delta --line-numbers"
                git config --global interactive.diffFilter "delta --color-only"
                git config --global delta.navigate true
                git config --global delta.light false
                ;;
            esac
          fi
          ;;
      esac
      ;;
  esac
fi
