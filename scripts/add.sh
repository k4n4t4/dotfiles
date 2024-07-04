# 1 target
# 2 origin
add() {
  # Variables
  target=""
  target_solved=""
  target_fmt=""
  origin=""
  origin_fmt=""
  link_fmt=""

  # Default Options
  opt_linksFilePath="$WORK_PATH/links/default.links"
  opt_makeParentDir=false
  opt_alignPath=false
  opt_recursive=false
  opt_depth=100
  opt_force=false
  opt_link=false

  # Solve Arguments
  opt_parser -n:1 --name:1 -d:1 --depth:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift 1
        break
        ;;
      ( -n | --name )
        opt_linksFilePath="$WORK_PATH/links/$2.links"
        shift 2
        ;;
      ( -p | --parent )
        opt_makeParentDir=true
        shift 1
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
      ( -l | --link )
        opt_link=true
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
    if $opt_makeParentDir; then
      _mkdir "$RET"
    else
      error "Directory Not Found: \"$RET\""
      info "Use the -p option or create a directory."
      return 1
    fi
  fi
  abs_path "$origin"
  origin="$RET"


  # Make Link List File
  _mkfile "$opt_linksFilePath"

  # Link Format
  link_fmt="dot"
  if $opt_recursive; then
    link_fmt="$link_fmt -r"
    if [ "$opt_depth" -ne 100 ]; then
      link_fmt="$link_fmt -d $opt_depth"
    fi
  fi
  link_fmt="$link_fmt --"
  path_without "$target" "$HOME"
  target_fmt="$RET"
  path_without "$origin" "$WORK_PATH/files"
  origin_fmt="$RET"
  qesc "$origin_fmt"
  link_fmt="$link_fmt $RET"
  case "$origin_fmt" in
    ( "$target_fmt" ) : ;;
    ( * )
      qesc "$target_fmt"
      link_fmt="$link_fmt $RET"
      ;;
  esac

  # Link Add
  info "\"$link_fmt\" >> \"$opt_linksFilePath\""
  printf "%s\n" "$link_fmt" >> "$opt_linksFilePath"


  $opt_link || return 0

  if $opt_recursive; then
    _store_recursive "$target" "$origin" "$opt_depth" "$opt_force"
  else
    _store "$target" "$origin" "$target_solved" "$opt_force"
  fi
}
