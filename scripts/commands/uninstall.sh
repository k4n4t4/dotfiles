uninstall() {
  info "Uninstall"

  uninstall_opt_force=false
  uninstall_opt_name="default"

  opt_parser -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -f | --force )
        uninstall_opt_force=true
        shift 1
        ;;
      ( * )
        error "Invalid Option: \"$1\""
        return 1
        ;;
    esac
  done

  if [ $# -eq 1 ]; then
    uninstall_opt_name="$1"
  fi

  uninstall_path="$WORK_PATH/links/$uninstall_opt_name.links"


  if [ -f "$uninstall_path" ]; then

    # shellcheck disable=SC2034
    dot_mode="uninstall"
    if $uninstall_opt_force; then
    # shellcheck disable=SC2034
      dot_opts="force"
    fi

    # shellcheck disable=SC1090
    . "$uninstall_path"

  else
    error "File not found: \"$uninstall_path\""
    return 1
  fi

}
