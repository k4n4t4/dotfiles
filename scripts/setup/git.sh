if cmd_exists git; then
    if [ "$DOT_SCRIPT_MODE" = install ] && ! file_exist "$HOME/.config/git/config"; then
        _print_info "git config"
        _print_ask "  Continue? [Y/n]: "
        # shellcheck disable=SC2154
        case "$_print_ask_RESULT" in
            ( [nN] ) : ;;
            ( * )
                _print_run mkdir -p "$HOME/.config/git"
                _print_run touch "$HOME/.config/git/config"

                _print_info "  git config user"
                _print_ask "  Continue? [Y/n]: "
                case "$_print_ask_RESULT" in
                    ( [nN] ) : ;;
                    ( * )
                        _print_ask "    email: "
                        if [ "$_print_ask_RESULT" != "" ]; then
                            _print_run git config --global user.email "$_print_ask_RESULT"
                        fi
                        _print_ask "    name: "
                        if [ "$_print_ask_RESULT" != "" ]; then
                            _print_run git config --global user.name "$_print_ask_RESULT"
                        fi
                        ;;
                esac
                if cmd_exists delta; then
                    _print_info "  git config delta"
                    _print_ask "  Continue? [Y/n]: "
                    case "$_print_ask_RESULT" in
                        ( [nN] ) : ;;
                        ( * )
                            _print_run git config --global core.pager "delta --line-numbers"
                            _print_run git config --global interactive.diffFilter "delta --color-only"
                            _print_run git config --global delta.navigate true
                            _print_run git config --global delta.light false
                            ;;
                    esac
                fi
                ;;
        esac
    fi
fi
