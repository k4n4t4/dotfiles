#!/bin/sh
set -eu


# Utils

dir_name() {
  RET="${1:-.}"
  RET="${RET%"${RET##*[!/]}"}"
  case "$RET" in
    ( "" )
      RET="/"
      ;;
    ( *"/"* )
      RET="${RET%/*}"
      RET="${RET%"${RET##*[!/]}"}"
      if [ -z "$RET" ]; then
        RET="/"
      fi
      ;;
    ( * )
      RET="."
      ;;
  esac
}

base_name() {
  RET="${1:-.}"
  RET="${RET%"${RET##*[!/]}"}"
  RET="${RET##*/}"
  if [ -z "$RET" ]; then
    RET="/"
  fi
}

abs_path() {
  TMP="$PWD"
  if [ -d "$1" ]; then
    cd -- "$1" || return 1
    RET="$PWD"
  else
    dir_name "$1"
    cd -- "$RET" || return 1
    base_name "$1"
    case "$PWD" in
      ( "/" | "//" )
        RET="/$RET"
        ;;
      ( * )
        RET="$PWD/$RET"
        ;;
    esac
  fi
  cd -- "$TMP" || return 1
}

abs_path_prefix() {
  set -- "$1" "${2:-.}" "$PWD"
  if [ -d "$2" ]; then
    cd -- "$2" || return 1
    abs_path "$1"
    cd -- "$3" || return 1
    return 0
  else
    cd -- "$3" || return 1
    return 1
  fi
}

cmd_exists() {
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

file_exists() {
  if [ -e "$1" ] || [ -L "$1" ]; then
    return 0
  else
    return 1
  fi
}

symlink_exists() {
  if [ -e "$1" ] && [ -L "$1" ]; then
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

is_deletable() {
  dir_name "$1"
  if [ -w "$RET" ] && [ -x "$RET" ]; then
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
        while [ -n "$_opt_parser_short_opts" ]; do
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

get_files() {
  TMP=""
  for i in "$1"/* "$1"/.*; do
    base_name "$i"
    case "$RET" in ( ".." | "." | "*" | ".*" )
      continue
    esac
    qesc "$i"
    TMP="$TMP $RET"
  done
  RET="$TMP"
}

get_files_recursive() {
  TMP=""
  _dir_max_depth="${2:-1000}"
  _include_dir="${3:-false}"
  _dir_depth=0
  set -- "$1"
  while [ $# -gt 0 ]; do
    _dir_stack=""
    _dir_depth=$((_dir_depth + 1))
    while [ $# -gt 0 ]; do
      for i in "$1"/* "$1"/.*; do
        base_name "$i"
        case "$RET" in ( '.' | '..' | '*' | '.*' ) continue ;; esac
        if [ -d "$i" ] && [ "$_dir_depth" -ne "$_dir_max_depth" ]; then
          qesc "$i"
          _dir_stack="$_dir_stack $RET"
          if $_include_dir; then
            TMP="$TMP $RET"
          fi
        else
          qesc "$i"
          TMP="$TMP $RET"
        fi
      done
      shift
    done
    eval 'set -- "$@" '"$_dir_stack"
  done
  RET="$TMP"
}

_stack_params=""
push_params() {
  TMP=""
  while [ $# -gt 0 ]; do
    qesc "$1"
    TMP="$TMP $RET"
    shift
  done
  qesc "$TMP"
  _stack_params="$RET $_stack_params"
}

# shellcheck disable=SC2120
pop_params() {
  eval "set -- $_stack_params"
  TMP="$1"
  shift
  _stack_params=""
  while [ $# -gt 0 ]; do
    qesc "$1"
    _stack_params="$_stack_params $RET"
    shift
  done
  RET="$TMP"
}

push_val() {
  qesc "$2"
  eval "$1"'="$'"$1"' $RET"'
}

pop_val() {
  TMP="$1"
  eval 'RET="$'"$1"'"'
  eval "set -- $RET"
  while [ $# -gt 1 ]; do
    qesc "$1"
    eval "$TMP"'="$'"$TMP"' $RET"'
    shift
  done
  RET="$1"
}


# Constants

ESC="$(printf "\033")"


# Message

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
  if $DOT_IS_YES_MODE; then
    RET="y"
  else
    read -r RET
  fi
}

msg_run() {
  printf "%s\n" " ${ESC}[35m[ RUN ]${ESC}[90m: ${ESC}[m$*"
  "$@"
  return $?
}


# Sub Commands

usage() {
  echo "Usage"
  echo "    $0 <SUB_COMMANDS> [options...]"
  echo
  echo "Sub Commands"
  echo "    help             show help"
  echo "    install          install dotfiles"
  echo "    uninstall        uninstall dotfiles"
  echo "    check            check dotfiles"
  echo "    cd               print dotfiles path"
  echo "    shellenv         print shellenv"
  echo "    git              run git"
  echo "    pull             run git pull"
}

shell_cd() {
  if [ "${1:-}" = "" ]; then
    printf "%s\n" "$DOTFILES_PATH"
  else
    printf "%s\n" "$DOTFILES_PATH/$1"
  fi
}

shellenv() {
  PARENT_SHELL="$(ps -o ppid= -p $$ | xargs -I{} ps -o comm= -p {})"
  case "$PARENT_SHELL" in
    ( bash | zsh )
cat << EOL
dm() {
  case "\${1:-}" in
    ( cd ) cd "\$(command dm "\$@")" ;;
    ( * ) command dm "\$@" ;;
  esac
}
EOL
      ;;
    ( fish )
cat << EOL
function dm;
  switch \$argv[1];
    case "cd";
      cd (command dm \$argv);
    case "*";
      command dm \$argv;
  end;
end;
EOL
      ;;
    ( * )
      msg_error "Not supported shell: $PARENT_SHELL"
      return 1
      ;;
  esac
}

# TODO: Add force option
# TODO: Add backup option
_dot_run_script() {
  DOT_IS_QUIET=false
  DOT_IS_YES_MODE=false
  DOT_ORIGIN_PATH="$DOTFILES_PATH"
  DOT_TARGET_PATH="$TARGET_PATH"
  DOT_SCRIPT_NAME=""
  DOT_SCRIPT_MODE="${1:-unknown}"

  shift

  case "$DOT_SCRIPT_MODE" in
    ( install )
      _dot() {
        _dot_link "$@"
      }
      ;;
    ( uninstall )
      _dot() {
        _dot_unlink "$@"
      }
      ;;
    ( check )
      _dot() {
        _dot_check "$@"
      }
      ;;
  esac

  opt_parser \
    t:1 target-path:1 \
    -- "$@"
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
      ( -y | --yes )
        shift
        DOT_IS_YES_MODE=true
        ;;
      ( -t | --target-path )
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

    if [ -f "$SCRIPTS_PATH/$DOT_SCRIPT_NAME.sh" ]; then
      # shellcheck disable=SC1090
      . "$SCRIPTS_PATH/$DOT_SCRIPT_NAME.sh"
    else
      msg_error "\"$DOT_SCRIPT_NAME\" is not found."
      return 1
    fi

    shift
  done
}


# dot

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
    ( "$DOTFILES_PATH/"* )
      set -- "$1" "\$DOTFILES_PATH${2#"$DOTFILES_PATH"}" "$3" "$4" "$5"
      ;;
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
    if file_exists "$RET"; then
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

  if file_exists "$2"; then
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

_dot_decorate_path() {
  RET="$1"
  case "$1" in
    ( "/"* )
      :
      ;;
    ( * )
      shift
      while [ $# -gt 0 ]; do
        if [ -n "$1" ]; then
          RET="$1/$RET"
        fi
        shift
      done
      ;;
  esac
}

_dot() {
  :
}

# TODO: Add force option
dot() {
  dot__origin_root="$DOT_ORIGIN_PATH"
  dot__target_root="$DOT_TARGET_PATH"
  dot__origin_prefix=""
  dot__target_prefix=""
  dot__recursive=false
  dot__depth=-1
  dot__ignore=""
  dot__origin=""
  dot__target=""

  opt_parser \
    d:1 depth:1 \
    i:1 ignore:1 \
    origin-root:1 \
    target-root:1 \
    origin-prefix:1 \
    target-prefix:1 \
    -- "$@"
  eval "set -- $RET"
  while [ $# -gt 0 ]; do
    case "$1" in
      ( -- ) shift ; break ;;
      ( --origin-root ) shift ; dot__origin_root="$1" ; shift 1 ;;
      ( --target-root ) shift ; dot__target_root="$1" ; shift 1 ;;
      ( --origin-prefix ) shift ; dot__origin_prefix="$1" ; shift 1 ;;
      ( --target-prefix ) shift ; dot__target_prefix="$1" ; shift 1 ;;
      ( -i | --ignore )
        shift
        qesc "$1"
        dot__ignore="$dot__ignore $RET"
        shift 1
        ;;
      ( -r | --recursive )
        shift
        dot__recursive="yes"
        ;;
      ( -d | --depth )
        shift
        if is_int "$1"; then
          dot__depth=$1
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

  dot__origin="$1"
  dot__target="${2:-"$1"}"
  _dot_decorate_path "$dot__origin" "$dot__origin_prefix" "$dot__origin_root"
  dot__origin="$RET"
  _dot_decorate_path "$dot__target" "$dot__target_prefix" "$dot__target_root"
  dot__target="$RET"


  if [ -e "$dot__origin" ]; then
    if [ -f "$dot__origin" ] || [ -d "$dot__origin" ]; then
      if [ "$dot__recursive" = "yes" ] && [ -d "$dot__origin" ]; then
        get_files_recursive "$dot__origin" "$dot__depth"
        eval "set -- $RET"
        while [ $# -gt 0 ]; do
          base_name "$1"
          if ! alt_match "$RET" "$dot__ignore"; then
            _dot "$1" "$dot__target/${1#"$dot__origin/"}"
          fi
          shift
        done
      else
        _dot "$dot__origin" "$dot__target"
      fi
    else
      msg_error "Not supported file type: $dot__origin"
    fi
  else
    msg_error "File not found: $dot__origin"
  fi
}


# Initialization

FILE_PATH="$(realpath "$0")"
dir_name "$FILE_PATH"
WORK_PATH="$RET"
KERNEL_NAME="$(uname -s)"

DOTFILES_PATH="$WORK_PATH/files"
SCRIPTS_PATH="$WORK_PATH/scripts"
TARGET_PATH="$HOME"


# Load Config

SET_DIR_PATH() {
  [ -z "${2:-}" ] && return 0

  if [ -d "$2" ]; then
    abs_path_prefix "$2" "$WORK_PATH"
    eval "$1"'="$RET"'
  else
    msg_error "Invalid path: $2"
    return 1
  fi
}

if [ -f "$WORK_PATH/config.sh" ]; then
  # shellcheck disable=SC1091
  . "$WORK_PATH/config.sh"
fi


# Main

main() {
  main__sub_command="unknown"

  case "$KERNEL_NAME" in
    ( Linux ) : ;;
    ( * )
      msg_error "\"$KERNEL_NAME\" is not supported."
      return 1
      ;;
  esac

  [ $# -eq 0 ] && set -- help
  case "$1" in
    ( help | h | usage | '-?' | '-h' | '--help' )
      main__sub_command="help"
      ;;
    ( install | i )
      main__sub_command="install"
      ;;
    ( uninstall | u )
      main__sub_command="uninstall"
      ;;
    ( check | c )
      main__sub_command="check"
      ;;
    ( cd )
      main__sub_command="cd"
      ;;
    ( shellenv )
      main__sub_command="shellenv"
      ;;
    ( git | g )
      main__sub_command="git"
      ;;
    ( pull | p )
      main__sub_command="pull"
      ;;
    ( debug )
      main__sub_command="debug"
      ;;
    ( * )
      msg_error "Invalid Sub Command: \"$1\""
      ;;
  esac
  shift
  case "$main__sub_command" in
    ( help ) usage ;;
    ( install | uninstall | check )
      _dot_run_script "$main__sub_command" "$@"
      ;;
    ( cd )
      shell_cd "$@"
      ;;
    ( shellenv )
      shellenv "$@"
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
      echo "WORK_PATH: $WORK_PATH"
      echo "KERNEL_NAME: $KERNEL_NAME"
      echo "FILE_PATH: $FILE_PATH"
      ;;
    ( * )
      usage
      return 1
      ;;
  esac
}

main "$@"
