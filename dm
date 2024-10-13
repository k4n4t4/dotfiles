#!/bin/dash
set -eu

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

if ! cmd_exist realpath; then
  echo '"realpath" is not exist.' >&2
  exit 1
fi

FILE_PATH="$(realpath "$0")"
dir_name "$FILE_PATH"
WORK_PATH="$RET"

. "$WORK_PATH/scripts/bootstrap.sh"


main() {

  if ${CHECK_INSTALL_LOCATION:-false} &&
    [ "$WORK_PATH" != "$HOME/dotfiles" ]; then
      warn "Installed location is not \"~/dotfiles\""
      info "Installed on \"$WORK_PATH\""
      ask "Continue? [y/N]: "
      case "$RET" in
        ( [Yy] ) : ;;
        ( * )
          log "Canceled."
          return 0
          ;;
      esac
  fi

  [ $# -eq 0 ] && set -- help

  case "$1" in
    ( help      | h ) shift ; usage "$@" ;;
    ( status    | s ) shift ; status "$@" ;;
    ( install   | i ) shift ; install "$@" ;;
    ( uninstall | u ) shift ; uninstall "$@" ;;
    ( check     | c ) shift ; check "$@" ;;
    ( * )
      error "Invalid Sub Command: \"$1\""
      usage
      return 1
      ;;
  esac
}

main "$@"
