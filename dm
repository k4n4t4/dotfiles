#!/bin/sh
set -eu

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
  case "$1" in ( "/" | "//" )
    set -- "$1" "" "$3"
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


# Check Command Exist
if ! cmd_exist realpath; then
  echo '"realpath" is not exist.' >&2
  exit 1
fi

# Check Shell
SHELL_PATH="$(realpath "/proc/$$/exe")"
SHELL_NAME="${SHELL_PATH##*"/"}"
case "$SHELL_NAME" in
  ( bash )
    shopt -s expand_aliases
    ;;
  ( zsh )
    emulate -R sh
    ;;
  ( yash | dash | ksh93 | busybox ) : ;;
  ( * )
    echo "\"$SHELL_PATH\" is not supported." >&2
    exit 1
    ;;
esac

# Check Kernel
KERNEL_NAME="$(uname -s)"
case "$KERNEL_NAME" in
  ( Linux* ) : ;;
  ( * )
    echo "\"$KERNEL_NAME\" is not supported." >&2
    exit 1
    ;;
esac

# Get Path
FILE_PATH="$(realpath "$0")"
dir_name "$FILE_PATH"
WORK_PATH="$RET"


# Source Libraries
. "$WORK_PATH/scripts/lib/print.sh"
. "$WORK_PATH/scripts/lib/utils.sh"
. "$WORK_PATH/scripts/lib/func.sh"

# Source Sub Commands
. "$WORK_PATH/scripts/usage.sh"

. "$WORK_PATH/scripts/new.sh"
. "$WORK_PATH/scripts/edit.sh"
. "$WORK_PATH/scripts/remove.sh"
. "$WORK_PATH/scripts/list.sh"

. "$WORK_PATH/scripts/add.sh"
. "$WORK_PATH/scripts/move.sh"
. "$WORK_PATH/scripts/clean.sh"

. "$WORK_PATH/scripts/store.sh"
. "$WORK_PATH/scripts/restore.sh"
. "$WORK_PATH/scripts/check.sh"

. "$WORK_PATH/scripts/link.sh"
. "$WORK_PATH/scripts/unlink.sh"
. "$WORK_PATH/scripts/confirm.sh"

. "$WORK_PATH/scripts/install.sh"
. "$WORK_PATH/scripts/uninstall.sh"
. "$WORK_PATH/scripts/verify.sh"

# Source Config
. "$WORK_PATH/scripts/default_config.sh"
. "$WORK_PATH/config.sh"


# Checking Install Location
if $CHECK_INSTALL_LOCATION && [ "$WORK_PATH" != "$HOME/dotfiles" ]; then
  warn "Installed location is not \"~/dotfiles\""
  info "Installed on \"$WORK_PATH\""
  ask "Continue? [y/N]: "
  case "$RET" in
    ( [Yy] ) : ;;
    ( * )
      log "Canceled."
      exit 1
      ;;
  esac
fi

# Main
main() {
  [ $# -eq 0 ] && set -- help
  case "$1" in

    ( help | usage | h | --help | -h )
      shift
      usage "$@"
      return $?
      ;;

    ( new  | n )
      shift
      new "$@"
      return $?
      ;;
    ( edit | e )
      shift
      edit "$@"
      return $?
      ;;
    ( remove | rm )
      shift
      remove "$@"
      return $?
      ;;
    ( list | ls )
      shift
      list "$@"
      return $?
      ;;

    ( add | a )
      shift
      add "$@"
      return $?
      ;;
    ( move | mv )
      shift
      move "$@"
      return $?
      ;;
    ( clean | cl )
      shift
      clean "$@"
      return $?
      ;;

    ( store | s )
      shift
      store "$@"
      return $?
      ;;
    ( restore | r )
      shift
      restore "$@"
      return $?
      ;;
    ( check | c )
      shift
      check "$@"
      return $?
      ;;

    ( link | ln )
      shift
      _install "$@"
      return $?
      ;;
    ( unlink | unln )
      shift
      _uninstall "$@"
      return $?
      ;;
    ( confirm | co )
      shift
      _verify "$@"
      return $?
      ;;

    ( install | i )
      shift
      install "$@"
      return $?
      ;;
    ( uninstall | u )
      shift
      uninstall "$@"
      return $?
      ;;
    ( verify | v )
      shift
      verify "$@"
      return $?
      ;;

    ( * )
      error "Invalid Sub Command: \"$1\""
      usage
      return 1
      ;;

  esac
}

main "$@"
