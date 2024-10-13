dot() {
  # shellcheck disable=SC2154
  case "$dot_mode" in
    ( "install" )
      if [ "$dot_opts" = "force"  ]; then
        set -- "$@" -f
      fi
      dot_install "$@"
      ;;
    ( "uninstall" )
      if [ "$dot_opts" = "force"  ]; then
        set -- "$@" -f
      fi
      dot_uninstall "$@"
      ;;
    ( "check" )
      dot_check "$@"
      ;;
    ( * )
      error "Invalid Mode: $dot_mode"
      return 1
      ;;
  esac
}


dot_arg_detection() {

  origin="$1"

  case "$origin" in
    ( "/"* )
      if [ $# -eq 1 ]; then
        error "To omit the argument, the first argument file must be under the \"files\" directory."
        return 1
      fi
      ;;
    ( * ) origin="$WORK_PATH/files/$origin" ;;
  esac

  if [ ! -e "$origin" ]; then
    error "File Not Found: \"$origin\""
    if [ -L "$origin" ]; then
      info "File is broken symlink."
    fi
    return 1
  fi

  abs_path "$origin"
  origin="$RET"


  target="${2:-"$1"}"

  case "$target" in
    ( "/"* ) : ;;
    ( * ) target="$HOME/$target" ;;
  esac

  if [ -L "$target" ]; then
    target_solved="$(realpath "$target")"
  else
    target_solved="$target"
  fi

  dir_name "$target"
  if [ ! -d "$RET" ]; then
    _mkdir "$RET"
  fi

  abs_path "$target"
  target="$RET"
}


dot_install() {

  dot_install_opt_force=false
  dot_install_opt_recursive=false
  dot_install_opt_depth=100

  opt_parser -d:1 --depth:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -f | --force )
        dot_install_opt_force=true
        shift 1
        ;;
      ( -r | --recursive )
        dot_install_opt_recursive=true
        shift 1
        ;;
      ( -d | --depth )
        if is_number "$2"; then
          dot_install_opt_depth=$2
        fi
        shift 2
        ;;
      ( * )
        error "Invalid Option: \"$1\""
        return 1
        ;;
    esac
  done
  if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    error "Wrong number of arguments."
    return 1
  fi


  if dot_arg_detection "$@"; then
    if $dot_install_opt_recursive; then
      if [ ! -d "$origin" ]; then
        error "\"$origin\" is not directory."
        return 1
      fi
      if [ ! -d "$target" ] && file_exist "$target"; then
        error "To use the -r option, \"$target\" must be a directory."
        return 1
      fi
      _install_link_recursive "$origin" "$target" "$dot_install_opt_depth" "$dot_install_opt_force"
    else
      _install_link "$origin" "$target" "$target_solved" "$dot_install_opt_force"
    fi
  else
    return 1
  fi
}


dot_uninstall() {

  dot_uninstall_opt_force=false
  dot_uninstall_opt_recursive=false
  dot_uninstall_opt_depth=100

  opt_parser -d:1 --depth:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -f | --force )
        dot_uninstall_opt_force=true
        shift 1
        ;;
      ( -r | --recursive )
        dot_uninstall_opt_recursive=true
        shift 1
        ;;
      ( -d | --depth )
        if is_number "$2"; then
          dot_uninstall_opt_depth=$2
        fi
        shift 2
        ;;
      ( * )
        error "Invalid Option: \"$1\""
        return 1
        ;;
    esac
  done
  if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    error "Wrong number of arguments."
    return 1
  fi


  if dot_arg_detection "$@"; then
    if $dot_uninstall_opt_recursive; then
      if [ ! -d "$origin" ]; then
        error "\"$origin\" is not directory."
        return 1
      fi
      if [ ! -d "$target" ] && file_exist "$target"; then
        error "To use the -r option, \"$target\" must be a directory."
        return 1
      fi
      _uninstall_unlink_recursive "$origin" "$target" "$dot_uninstall_opt_depth" "$dot_uninstall_opt_force"
    else
      _uninstall_unlink "$origin" "$target" "$target_solved" "$dot_uninstall_opt_force"
    fi
  else
    return 1
  fi
}


dot_check() {

  dot_check_opt_recursive=false
  dot_check_opt_depth=100

  opt_parser -d:1 --depth:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -r | --recursive )
        dot_check_opt_recursive=true
        shift 1
        ;;
      ( -d | --depth )
        if is_number "$2"; then
          dot_check_opt_depth=$2
        fi
        shift 2
        ;;
      ( * )
        error "Invalid Option: \"$1\""
        return 1
        ;;
    esac
  done
  if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    error "Wrong number of arguments."
    return 1
  fi


  if dot_arg_detection "$@"; then
    if $dot_check_opt_recursive; then
      if [ ! -d "$origin" ]; then
        error "\"$origin\" is not directory."
        return 1
      fi
      if [ ! -d "$target" ] && file_exist "$target"; then
        error "To use the -r option, \"$target\" must be a directory."
        return 1
      fi
      _verify_check_recursive "$origin" "$target" "$dot_check_opt_depth"
    else
      _verify_check "$origin" "$target" "$target_solved"
    fi
  else
    return 1
  fi
}
