install() {
  info "Install"

  install_opt_force=false
  install_opt_name="default"

  opt_parser -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -f | --force )
        install_opt_force=true
        shift 1
        ;;
      ( * )
        error "Invalid Option: \"$1\""
        return 1
        ;;
    esac
  done

  if [ $# -eq 1 ]; then
    install_opt_name="$1"
  fi

  install_path="$WORK_PATH/links/$install_opt_name.links"


  if [ -f "$install_path" ]; then

    # shellcheck disable=SC2034
    dot_mode="install"
    if $install_opt_force; then
    # shellcheck disable=SC2034
      dot_opts="force"
    fi

    # shellcheck disable=SC1090
    . "$install_path"

  else
    error "File not found: \"$install_path\""
    return 1
  fi

}
