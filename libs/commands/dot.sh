commands_run() {
  DOT_TARGET_PATH="$HOME"
  DOT_SCRIPT_NAME="default"

  opt_parser p:1 path:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift
        break
        ;;
      ( -p | --path )
        shift
        DOT_TARGET_PATH="$1"
        shift 1
        ;;
      ( * )
        msg_error "Invalid Option."
        return 1
        ;;
    esac
  done

  if [ $# -ne 0 ]; then
    if [ $# -eq 1 ]; then
      DOT_SCRIPT_NAME="$1"
    else
      msg_error "Invalid Arguments."
      return 1
    fi
  fi


  if [ -f "$WORK_PATH/scripts/$DOT_SCRIPT_NAME.sh" ]; then
    # shellcheck disable=SC1090
    . "$WORK_PATH/scripts/$DOT_SCRIPT_NAME.sh"
  else
    msg_error "\"$DOT_SCRIPT_NAME\" is not found."
    return 1
  fi
}

dot() {
  DOT_OPT_ORIGIN_PREFIX="$WORK_PATH/files"
  DOT_OPT_ORIGIN_SUFFIX=""
  DOT_OPT_TARGET_PREFIX="$DOT_TARGET_PATH"
  DOT_OPT_TARGET_SUFFIX=""
  DOT_OPT_RECURSIVE="no"
  DOT_OPT_DEPTH=100
  DOT_OPT_IGNORE=""

  opt_parser \
    d:1 depth:1 \
    i:1 ignore:1 \
    origin-prefix:1 \
    origin-suffix:1 \
    target-prefix:1 \
    target-suffix:1 \
    -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- ) shift ; break ;;
      ( --origin-prefix ) shift ; DOT_OPT_ORIGIN_PREFIX="$1" ; shift 1 ;;
      ( --origin-suffix ) shift ; DOT_OPT_ORIGIN_SUFFIX="$1" ; shift 1 ;;
      ( --target-prefix ) shift ; DOT_OPT_TARGET_PREFIX="$1" ; shift 1 ;;
      ( --target-suffix ) shift ; DOT_OPT_TARGET_SUFFIX="$1" ; shift 1 ;;
      ( -i | --ignore )
        shift
        qesc "$1"
        DOT_OPT_IGNORE="$DOT_OPT_IGNORE $RET"
        shift 1
        ;;
      ( -r | --recursive )
        shift
        DOT_OPT_RECURSIVE="yes"
        ;;
      ( -d | --depth )
        shift
        if is_number "$1"; then
          DOT_OPT_DEPTH=$1
        fi
        shift 1
        ;;
      ( * )
        msg_error "Invalid Option: $1"
        return 1
        ;;
    esac
  done
  if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    msg_error "Wrong number of arguments."
    return 1
  fi

  DOT_ARG_ORIGIN="$1"
  case "$DOT_ARG_ORIGIN" in
    ( "/"* )
      : Is absolute path.
      ;;
    ( * )
      case "$DOT_OPT_ORIGIN_SUFFIX" in
        ( "" )
          DOT_ARG_ORIGIN="$DOT_OPT_ORIGIN_PREFIX/$DOT_ARG_ORIGIN"
          ;;
        ( * )
          DOT_ARG_ORIGIN="$DOT_OPT_ORIGIN_PREFIX/$DOT_OPT_ORIGIN_SUFFIX/$DOT_ARG_ORIGIN"
          ;;
      esac
      ;;
  esac
  DOT_ARG_TARGET="${2:-"$1"}"
  case "$DOT_ARG_TARGET" in
    ( "/"* )
      : Is absolute path.
      ;;
    ( * )
      case "$DOT_OPT_TARGET_SUFFIX" in
        ( "" )
          DOT_ARG_TARGET="$DOT_OPT_TARGET_PREFIX/$DOT_ARG_TARGET"
          ;;
        ( * )
          DOT_ARG_TARGET="$DOT_OPT_TARGET_PREFIX/$DOT_OPT_TARGET_SUFFIX/$DOT_ARG_TARGET"
          ;;
      esac
      ;;
  esac

  if [ -e "$DOT_ARG_ORIGIN" ]; then
    if [ -f "$DOT_ARG_ORIGIN" ] || [ -d "$DOT_ARG_ORIGIN" ]; then
      if [ "$DOT_OPT_RECURSIVE" = "yes" ] && [ -d "$DOT_ARG_ORIGIN" ]; then
        OLD_IFS="$IFS"
        IFS="$NL"
        set -- "$DOT_ARG_ORIGIN"
        _dot_rec_current_depth=0
        while [ $# -gt 0 ]; do
          _dot_rec_current_depth=$((_dot_rec_current_depth + 1))
          _dot_rec_dir_stack=""
          while [ $# -gt 0 ]; do
            for _dot_rec_entry_origin in "$1"/* "$1"/.*; do
              base_name "$_dot_rec_entry_origin"
              case "$RET" in ( '.' | '..' ) continue ;; esac
              [ -e "$_dot_rec_entry_origin" ] || continue
              alt_match "$RET" "$DOT_OPT_IGNORE" && continue
              if [ -d "$_dot_rec_entry_origin" ] && [ "$_dot_rec_current_depth" -ne "$DOT_OPT_DEPTH" ]; then
                qesc "$_dot_rec_entry_origin"
                _dot_rec_dir_stack="$_dot_rec_dir_stack $RET"
              else
                path_without "$_dot_rec_entry_origin" "$DOT_ARG_ORIGIN"
                _dot_rec_entry_target="$DOT_ARG_TARGET/$RET"
                case "$SUBCOMMAND" in
                  ( 'install' ) _dot_link "$_dot_rec_entry_origin" "$_dot_rec_entry_target" ;;
                  ( 'uninstall' ) _dot_unlink "$_dot_rec_entry_origin" "$_dot_rec_entry_target" ;;
                  ( 'check' ) _dot_check "$_dot_rec_entry_origin" "$_dot_rec_entry_target" ;;
                esac
              fi
            done
            shift
          done
          eval "set -- $_dot_rec_dir_stack"
        done
        IFS="$OLD_IFS"
      else
        case "$SUBCOMMAND" in
          ( 'install' ) _dot_link "$DOT_ARG_ORIGIN" "$DOT_ARG_TARGET" ;;
          ( 'uninstall' ) _dot_unlink "$DOT_ARG_ORIGIN" "$DOT_ARG_TARGET" ;;
          ( 'check' ) _dot_check "$DOT_ARG_ORIGIN" "$DOT_ARG_TARGET" ;;
        esac
      fi
    else
      msg_error "Not supported file type: $DOT_ARG_ORIGIN"
    fi
  else
    msg_error "File not found: $DOT_ARG_ORIGIN"
  fi
}


_dot_ask_continue() {
  msg_ask "Continue? [Y/n]: "
  case "$RET" in
    ( [nN] )
      RET=1
      ;;
    ( * )
      RET=0
      ;;
  esac
}

_dot_link() {
  dir_name "$2"
  if [ ! -d "$RET" ]; then
    if file_exist "$RET"; then
      msg_error "Cannot make directory: $RET (Already Exist)"
      ask_continue
      return "$RET"
    else
      if mkdir -p -- "$RET"; then
        msg_log "Make directory: $RET"
      else
        msg_fatal "Cannot make directory: $RET (Faild)"
        return 1
      fi
    fi
  fi

  if file_exist "$2"; then
    if [ -L "$2" ] && [ "$(realpath "$2")" = "$1" ]; then
      msg_log "$1 <-> $2 (Already Linked)"
      return 0
    else
      msg_error "$1 --x $2 (Already Exist)"
      ask_continue
      return "$RET"
    fi
  fi

  if ln -s -- "$1" "$2"; then
    msg_log "$1 --> $2"
  else
    msg_fatal "$1 --x $2 (Faild)"
    return 1
  fi
}

_dot_unlink() {
  if [ -e "$2" ] && [ -L "$2" ] && [ "$(realpath "$2")" = "$1" ]; then
    if unlink -- "$2"; then
      msg_log "$1 x-x $2"
    else
      msg_fatal "$1 -?- $2 (Faild)"
      return 1
    fi
  else
    msg_log "$1 x-x $2 (Already Unlinked)"
  fi
}

_dot_check() {
  if [ -e "$2" ] && [ -L "$2" ] && [ "$(realpath "$2")" = "$1" ]; then
    msg_log "$1 <-> $2"
  else
    msg_warn "$1 -?- $2"
  fi
}
