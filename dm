#!/bin/sh
set -eu


NL='
'
ESC="$(printf "\033")"

dir_name() {
  RET="${1:-"."}"
  RET="${RET%"${RET##*[!"/"]}"}"
  case "$RET" in
    ( "" ) RET="/" ;;
    ( *"/"* )
      RET="${RET%"/"*}"
      RET="${RET%"${RET##*[!"/"]}"}"
      case "$RET" in ( "" )
        RET="/"
      esac
      ;;
    ( * ) RET="." ;;
  esac
}

base_name() {
  RET="${1:-}"
  case "$RET" in
    ( "" ) : ;;
    ( * )
      RET="${RET%"${RET##*[!"/"]}"}"
      case "$RET" in
        ( "" ) RET="/" ;;
        ( * ) RET="${RET##*"/"}" ;;
      esac
      ;;
  esac
}

abs_path() {
  OLD_PWD="$PWD"
  dir_name "$1"
  cd -- "$RET" || return 1
  base_name "$1"
  set -- "$PWD" "/" "$RET"
  case "$1" in
    ( "/" | "//" )
      set -- "$1" "" "$3"
      ;;
  esac
  case "$3" in
    ( "/" )  RET="$1$2" ;;
    ( "." | "" )  RET="$1" ;;
    ( ".." )
      cd ..
      RET="$PWD"
      ;;
    ( * ) RET="$1$2$3" ;;
  esac
  cd -- "$OLD_PWD" || return 1
}

cmd_exist() {
  if command -v -- "$1" > /dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

is_empty_dir() {
  set -- "${1:-.}"
  set -- "$1"/* "$1"/.*
  while [ $# -gt 0 ]; do
    base_name "$1"
    case "$RET" in
      ( "." | ".." | "*" | ".*" ) shift 1 ;;
      ( * ) return 1 ;;
    esac
  done
  return 0
}

file_exist() {
  if [ -e "$1" ] || [ -L "$1" ]; then
    return 0
  else
    return 1
  fi
}

is_broken_symlink() {
  if [ ! -e "$1" ] && [ -L "$1" ]; then
    return 0
  else
    return 1
  fi
}

is_number() {
  case "$1" in
    ( *[!0123456789]* )
      return 1
      ;;
    ( * )
      return 0
      ;;
  esac
}

is_int() {
  is_number "${1#"-"}"
}

qesc() {
  RET="$1"
  set -- ""
  while : ; do
    case "$RET" in
      ( *"'"* )
        set -- "$1${RET%%"'"*}'\\''"
        RET="${RET#*"'"}"
        ;;
      ( * )
        RET="'$1$RET'"
        break
        ;;
    esac
  done
}

opt_parser_get_arg_count() {
  RET="$1"
  eval "set -- $2"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( "$RET:"?* )
        RET="${1#"$RET:"}"
        return 0
        ;;
    esac
    shift
  done
  RET=0
  return 0
}

opt_parser() {
  _opt_parser_options=""
  _opt_parser_normal_args=""
  _opt_parser_option_args=""

  while [ $# -gt 0 ]; do

    case "$1" in
      ( '--' )
        shift
        break
        ;;
      ( ?':'?* ) qesc "-$1" ;;
      ( ?*':'?* ) qesc "--$1" ;;
      ( ? ) qesc "-$1:1" ;;
      ( ?* ) qesc "--$1:1" ;;
      ( * )
        shift
        continue
        ;;
    esac

    _opt_parser_options="$_opt_parser_options $RET"
    shift
  done

  while [ $# -gt 0 ]; do
    case "$1" in
      ( '--' )
        shift
        break
        ;;
      ( '--'* | '-'? )
        case "$1" in ( "--"?*"="* )
          RET="$1"
          shift
          set -- "${RET%%"="*}" "${RET#*"="}" "$@"
          continue
        esac

        opt_parser_get_arg_count "$1" "$_opt_parser_options"
        _opt_parser_arg_count="$RET"

        if [ $# -gt "$_opt_parser_arg_count" ]; then
          while [ "$_opt_parser_arg_count" -ge 0 ]; do
            qesc "$1"
            _opt_parser_option_args="$_opt_parser_option_args $RET"
            shift
            _opt_parser_arg_count=$((_opt_parser_arg_count - 1))
          done
        else
          shift
        fi
        ;;
      ( '-'?* )
        opt_parser_get_arg_count "${1%"${1#??}"}" "$_opt_parser_options"
        if [ "$RET" -eq 1 ]; then
          RET="$1"
          shift
          set -- "${RET%"${RET#??}"}" "${RET#??}" "$@"
          continue
        fi

        _opt_parser_short_opts="${1#'-'}"
        while [ "$_opt_parser_short_opts" != "" ]; do
          _opt_parser_short_opt="-${_opt_parser_short_opts%"${_opt_parser_short_opts#?}"}"
          opt_parser_get_arg_count "$_opt_parser_short_opt" "$_opt_parser_options"
          if [ "$RET" -eq 0 ] && [ "$_opt_parser_short_opt" != '--' ]; then
            qesc "$_opt_parser_short_opt"
            _opt_parser_option_args="$_opt_parser_option_args $RET"
          fi
          _opt_parser_short_opts="${_opt_parser_short_opts#?}"
        done
        shift
        ;;
      ( * )
        qesc "$1"
        _opt_parser_normal_args="$_opt_parser_normal_args $RET"
        shift
        ;;
    esac
  done

  while [ $# -gt 0 ]; do
    qesc "$1"
    _opt_parser_normal_args="$_opt_parser_normal_args $RET"
    shift
  done

  RET="${_opt_parser_option_args#' '} -- ${_opt_parser_normal_args#' '}"
}

match() {
  RET="$1"
  eval "set -- $2"
  while [ $# -gt 0 ]; do
    eval 'case "$1" in ( '"$RET"' ) return 0 ;; esac'
    shift
  done
  return 1
}

alt_match() {
  RET="$1"
  eval "set -- $2"
  while [ $# -gt 0 ]; do
    eval 'case "$RET" in ( '"$1"' ) return 0 ;; esac'
    shift
  done
  return 1
}

true() {
  return 0
}

false() {
  return 1
}


msg_log() {
  printf "%s\n" " ${ESC}[32m[ LOG ]${ESC}[90m: ${ESC}[m$*"
}

msg_success() {
  printf "%s\n" " ${ESC}[92m[ SUC ]${ESC}[90m: ${ESC}[m$*"
}

msg_info() {
  printf "%s\n" " ${ESC}[94m[ INF ]${ESC}[90m: ${ESC}[m$*"
}

msg_debug() {
  printf "%s\n" " ${ESC}[97m${ESC}[43m[ DBG ]${ESC}[m${ESC}[90m: ${ESC}[m$*"
}

msg_warn() {
  printf "%s\n" " ${ESC}[93m[ WRN ]${ESC}[90m: ${ESC}[m$*" >&2
}

msg_error() {
  printf "%s\n" " ${ESC}[91m[ ERR ]${ESC}[90m: ${ESC}[m$*" >&2
}

msg_fatal() {
  printf "%s\n" " ${ESC}[97m${ESC}[41m[ FTL ]${ESC}[m${ESC}[90m: ${ESC}[m$*" >&2
}

msg_ask() {
  printf "%s" " ${ESC}[33m[ ASK ]${ESC}[90m: ${ESC}[m$*"
  read -r RET
}


usage() {
  echo "Usage"
  echo "    $0 <SUB_COMMANDS> [options...]"
  echo
  echo "Sub Commands"
  echo "    help             show help"
  echo "    debug            show debug"
  echo "    install          install dotfiles"
  echo "    uninstall        uninstall dotfiles"
  echo "    check            check dotfiles"
  echo "    git              run git"
  echo "    pull             run git pull"
}

source_script() {
  # shellcheck disable=SC1090
  . "$WORK_PATH/scripts/$1.sh"
}

run_script() {
  [ $# -eq 0 ] && return 1
  DOT_SCRIPT_MODE="$1"
  shift

  DOT_IS_QUIET=false
  DOT_TARGET_PATH="$HOME"

  opt_parser p:1 path:1 -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- )
        shift
        break
        ;;
      ( -q | --quiet )
        shift
        DOT_IS_QUIET=true
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

  [ $# -eq 0 ] && set -- "default"

  while [ $# -gt 0 ]; do
    DOT_SCRIPT_NAME="$1"

    if [ -f "$WORK_PATH/scripts/$DOT_SCRIPT_NAME.sh" ]; then
      source_script "$DOT_SCRIPT_NAME"
    else
      msg_error "\"$DOT_SCRIPT_NAME\" is not found."
      return 1
    fi

    shift
  done
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
                _dot_rec_entry_target="$DOT_ARG_TARGET/${_dot_rec_entry_origin#"$DOT_ARG_ORIGIN/"}"
                case "$DOT_SCRIPT_MODE" in
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
        case "$DOT_SCRIPT_MODE" in
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
_dot_msg() {
  set -- "$1" "$2" "$3" "$4" "${5:-}"

  if $DOT_IS_QUIET; then
    case "$1" in
      ( log | info )
        return 0
        ;;
    esac
  fi

  case "$2" in
    ( "$WORK_PATH/"* )
      set -- "$1" "\$WORK_PATH${2#"$WORK_PATH"}" "$3" "$4" "$5"
      ;;
  esac
  case "$4" in
    ( "$HOME/"* )
      set -- "$1" "$2" "$3" "~${4#"$HOME"}" "$5"
      ;;
  esac
  if [ "$5" = "" ]; then
    "msg_$1" "$2 ${ESC}[90m$3${ESC}[m $4"
  else
    "msg_$1" "$2 ${ESC}[90m$3${ESC}[m $4 ${ESC}[90m$5${ESC}[m"
  fi
}
_dot_link() {
  dir_name "$2"
  if [ ! -d "$RET" ]; then
    if file_exist "$RET"; then
      msg_error "Cannot make directory: $RET (Already Exist)"
      _dot_ask_continue
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
      _dot_msg log "$1" "<->" "$2" "(Already Linked)"
      return 0
    else
      _dot_msg error "$1" "--x" "$2" "(Already Exist)"
      _dot_ask_continue
      return "$RET"
    fi
  fi

  if ln -s -- "$1" "$2"; then
    _dot_msg success "$1" "-->" "$2"
  else
    _dot_msg fatal "$1" "--x" "$2" "(Faild)"
    return 1
  fi
}
_dot_unlink() {
  if [ -e "$2" ] && [ -L "$2" ] && [ "$(realpath "$2")" = "$1" ]; then
    if unlink -- "$2"; then
      _dot_msg success "$1" "x-x" "$2"
    else
      _dot_msg fatal "$1" "-?-" "$2" "(Faild)"
      return 1
    fi
  else
    _dot_msg log "$1" "x-x" "$2" "(Already Unlinked)"
  fi
}
_dot_check() {
  if [ -e "$2" ] && [ -L "$2" ] && [ "$(realpath "$2")" = "$1" ]; then
    _dot_msg success "$1" "<->" "$2"
  else
    _dot_msg warn "$1" "-?-" "$2"
  fi
}


FILE_PATH="$(realpath "$0")"
WORK_PATH="${FILE_PATH%"/"*}"
[ "$WORK_PATH" = "" ] && WORK_PATH="/"
KERNEL_NAME="$(uname -s)"
SUBCOMMAND="unknown"


main() {
  case "$KERNEL_NAME" in
    ( Linux ) : ;;
    ( * )
      msg_error "\"$KERNEL_NAME\" is not supported."
      return 1
      ;;
  esac

  [ $# -eq 0 ] && set -- help
  case "$1" in
    ( help | h | usage | '-?' | '-h' | '--help' ) SUBCOMMAND="help" ;;
    ( install | i ) SUBCOMMAND="install" ;;
    ( uninstall | u ) SUBCOMMAND="uninstall" ;;
    ( check | c ) SUBCOMMAND="check" ;;
    ( git | g ) SUBCOMMAND="git" ;;
    ( pull | p ) SUBCOMMAND="pull" ;;
    ( debug | d ) SUBCOMMAND="debug" ;;
    ( * ) msg_error "Invalid Sub Command: \"$1\"" ;;
  esac
  shift
  case "$SUBCOMMAND" in
    ( help ) usage ;;
    ( install | uninstall | check )
      run_script "$SUBCOMMAND" "$@"
      ;;
    ( git )
      cd -- "$WORK_PATH"
      git "$@"
      ;;
    ( pull )
      cd -- "$WORK_PATH"
      git pull
      ;;
    ( debug )
      msg_info "Debug"
      msg_log "        HOME = \"$HOME\""
      msg_log "         PWD = \"$PWD\""
      msg_log "   FILE_PATH = \"$FILE_PATH\""
      msg_log "   WORK_PATH = \"$WORK_PATH\""
      msg_log " KERNEL_NAME = \"$KERNEL_NAME\""
      msg_log "  SUBCOMMAND = \"$SUBCOMMAND\""
      ;;
    ( * )
      usage
      return 1
      ;;
  esac
}

main "$@"
