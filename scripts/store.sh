# 1 target
# 2 origin
store() {
  # Variables
  target=""
  target_solved=""
  origin=""

  # Default Options
  opt_alignPath=false
  opt_recursive=false
  opt_depth=100
  opt_force=false

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
      ( -f | --force )
        opt_force=true
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
  if $opt_recursive && [ ! -d "$target" ]; then
    error "To use the -r option, it must be a directory."
    return 1
  fi
  if [ -L "$target" ]; then
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
  dir_name "$origin"
  if [ ! -d "$RET" ]; then
    _mkdir "$RET"
  fi
  abs_path "$origin"
  origin="$RET"


  if $opt_recursive; then
    _store_recursive "$target" "$origin" "$opt_depth" "$opt_force"
  else
    _store "$target" "$origin" "$target_solved" "$opt_force"
  fi
}
