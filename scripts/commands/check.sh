check() {
  info "Check"

  check_opt_name="default"

  opt_parser -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( * )
        error "Invalid Option: \"$1\""
        return 1
        ;;
    esac
  done

  if [ $# -eq 1 ]; then
    check_opt_name="$1"
  fi

  check_path="$WORK_PATH/links/$check_opt_name.links"


  if [ -f "$check_path" ]; then

    # shellcheck disable=SC2034
    dot_mode="check"

    # shellcheck disable=SC1090
    . "$check_path"

  else
    error "File not found: \"$check_path\""
    return 1
  fi

}
