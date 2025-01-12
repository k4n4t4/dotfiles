if cmd_exist git; then
  info "git config"
  ask "  Continue? [Y/n]: "
  case "$RET" in
    ( [nN] ) : ;;
    ( * )
      info "  git config user"
      ask "  Continue? [Y/n]: "
      case "$RET" in
        ( [nN] ) : ;;
        ( * )
          ask "    email: "
          if [ "$RET" != "" ]; then
            git config --global user.email "$RET"
          fi
          ask "    name: "
          if [ "$RET" != "" ]; then
            git config --global user.name "$RET"
          fi
          ;;
      esac
      if cmd_exist delta; then
        info "  git config delta"
        ask "  Continue? [Y/n]: "
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
fi

