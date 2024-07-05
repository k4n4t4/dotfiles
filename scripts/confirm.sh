# 1 origin
# 2 target
_verify() {
  origin=""
  target=""
  target_solved=""

  # Default Options
  opt_recursive=false
  opt_depth=100

  # Solve Arguments
  opt_parser -d:1 --depth:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -r | --recursive )
        opt_recursive=true
        shift 1
        ;;
      ( -d | --depth )
        if is_number "$2"; then
          opt_depth="$2"
        fi
        shift 2
        ;;
      ( -f | --force ) : ;;
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


  # (origin)
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
    [ -L "$origin" ] && info "File is broken symlink."
    return 1
  fi
  if $opt_recursive && [ ! -d "$origin" ]; then
      error "To specify a directory, you must use the -r option."
      return 1
  fi
  abs_path "$origin"
  origin="$RET"

  # (target)
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
  if $opt_recursive && [ ! -d "$target" ] && file_exist "$target"; then
    info "To use the -r option, it must be a directory."
    return 0
  fi
  abs_path "$target"
  target="$RET"


  if $opt_recursive; then
    _verify_check_recursive "$origin" "$target" "$opt_depth"
  else
    _verify_check "$origin" "$target" "$target_solved"
  fi
}
