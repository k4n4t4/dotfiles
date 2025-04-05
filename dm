#!/bin/sh
set -eu


if ! command -v -- "realpath" > /dev/null 2>&1; then
  echo '"realpath" is not exist.' >&2
  exit 1
fi

FILE_PATH="$(realpath "$0")"
WORK_PATH="${FILE_PATH%"/"*}"
case "$WORK_PATH" in ( "" )
  WORK_PATH="/"
esac

. "$WORK_PATH/scripts/bootstrap.sh"


main() {
  [ $# -eq 0 ] && set -- help

  case "$1" in
    ( help      | h ) shift ; usage "$@" ;;
    ( debug     | d ) shift ; debug "$@" ;;
    ( install   | i ) shift ; install "$@" ;;
    ( uninstall | u ) shift ; uninstall "$@" ;;
    ( check     | c ) shift ; check "$@" ;;
    ( pull      | p )
      cd -- "$WORK_PATH"
      git pull
      ;;
    ( status    | s )
      cd -- "$WORK_PATH"
      git status
      ;;
    ( git       | g )
      shift
      cd -- "$WORK_PATH"
      git "$@"
      ;;
    ( * )
      error "Invalid Sub Command: \"$1\""
      usage
      return 1
      ;;
  esac
}

main "$@"
