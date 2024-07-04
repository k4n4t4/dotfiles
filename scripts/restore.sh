# 1 target
# 2 origin
restore() {
  # Variables
  target=""
  target_solved=""
  origin=""

  # Default Options
  opt_alignPath=false
  opt_recursive=false
  opt_depth=100
  opt_clean=true

  # Solve Arguments
  opt_parser -d:1 --depth:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -a | --align-path )
        opt_alignPath=true
        shift 1
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
      ( -c | --not-clean )
        opt_clean=false
        shift 1
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


  # (target)
  target="$1"
  if [ ! -e "$target" ]; then
    error "File Not Found: \"$target\""
    [ -L "$target" ] && info "File is broken symlink."
    return 1
  fi
  if [ ! -L "$target" ]; then
    if $opt_recursive; then
      if [ ! -d "$target" ]; then
        error "To specify a directory, you must use the -r option."
        return 1
      fi
    else
      info "\"$target\" is already restored."
      return 0
    fi
  else
    if $opt_recursive; then
      error "The -r option cannot be specified for symbolic."
      return 1
    fi
    target_solved="$(realpath "$target")"
  fi
  abs_path "$target"
  target="$RET"


  # (origin)
  if [ $# -eq 1 ]; then
    case "$target" in
      ( "$HOME/"* )
        path_without "$target" "$HOME"
        origin="$WORK_PATH/files/$RET"
        ;;
      ( * )
        error "To omit the argument, the first argument file must be under the home directory."
        return 1
        ;;
    esac
  else
    origin="$2"
    case "$origin" in
      ( "/"* | "./"* | "../"* ) : ;;
      ( * )
        if $opt_alignPath; then
          case "$target" in
            ( "$HOME/"* )
              path_without "$target" "$HOME"
              dir_name "$RET"
              origin="$WORK_PATH/files/$RET/$origin"
              ;;
            ( * )
              error "To use the -a option, the first argument file must be under the home directory."
              return 1
              ;;
          esac
        else
          origin="$WORK_PATH/files/$origin"
        fi
        ;;
    esac
  fi
  if [ ! -e "$origin" ]; then
    info "File Not Found: \"$origin\""
    if [ -L "$origin" ]; then
      info "File is broken symlink."
      return 1
    fi
    return 0
  elif $opt_recursive; then
    if [ ! -d "$origin" ]; then
      error "To use the -r option, \"$origin\" must be a directory."
      return 1
    fi
  fi
  abs_path "$origin"
  origin="$RET"


  if $opt_recursive; then
    _restore_recursive "$target" "$origin" "$opt_depth"
  else
    _restore "$target" "$origin" "$target_solved"
  fi
  if $opt_clean; then
    clean
  fi
}
