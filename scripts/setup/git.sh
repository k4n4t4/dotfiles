if cmd_exists git; then
    if [ "$SCRIPT_MODE" = "install" ] && ! file_exist "$HOME/.config/git/config"; then
        _print_info "git config"
        printf "  Continue? [Y/n]: "
        read -r RET

        case "$RET" in
            ( [nN] ) : ;;
            ( * )
                _print_run mkdir -p "$HOME/.config/git"
                _print_run touch "$HOME/.config/git/config"

                _print_info "  git config user"
                printf "  Continue? [Y/n]: "
                read -r RET

                case "$RET" in
                    ( [nN] ) : ;;
                    ( * )
                        printf "    email: "
                        read -r RET
                        if [ "$RET" != "" ]; then
                            _print_run git config --global user.email "$RET"
                        fi

                        printf "    name: "
                        read -r RET
                        if [ "$RET" != "" ]; then
                            _print_run git config --global user.name "$RET"
                        fi
                        ;;
                esac

                if cmd_exists delta; then
                    _print_run git config --global core.pager "delta --line-numbers"
                    _print_run git config --global interactive.diffFilter "delta --color-only"
                    _print_run git config --global delta.navigate true
                    _print_run git config --global delta.light false
                fi
                ;;
        esac
    fi
fi
