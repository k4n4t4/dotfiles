if [ "$DOT_SCRIPT_MODE" = install ] && ! file_exist "$HOME/.gitconfig"; then
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
            msg_run git config --global user.email "$RET"
          fi
          msg_ask "    name: "
          if [ "$RET" != "" ]; then
            msg_run git config --global user.name "$RET"
          fi
          ;;
      esac
      if cmd_exist delta; then
        msg_info "  git config delta"
        msg_ask "  Continue? [Y/n]: "
        case "$RET" in
          ( [nN] ) : ;;
          ( * )
            msg_run git config --global core.pager "delta --line-numbers"
            msg_run git config --global interactive.diffFilter "delta --color-only"
            msg_run git config --global delta.navigate true
            msg_run git config --global delta.light false
            ;;
        esac
      fi
      ;;
  esac
fi
