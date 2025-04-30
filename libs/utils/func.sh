# shellcheck disable=SC2034

NL='
'

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

path_without() {
  RET="${1#"$2/"}"
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
    case "$1" in ( "$RET:"?* )
      RET="${1#"$RET:"}"
      return 0
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


ESC="$(printf "\033")"

msg_log() {
  printf "%s\n" " ${ESC}[32m[ LOG ]${ESC}[90m: ${ESC}[m$*"
}

msg_success() {
  printf "%s\n" " ${ESC}[92m[ SUC ]${ESC}[90m: ${ESC}[32m$*${ESC}[m"
}

msg_info() {
  printf "%s\n" " ${ESC}[94m[ INF ]${ESC}[90m: ${ESC}[4m${ESC}[34m$*${ESC}[m"
}

msg_debug() {
  printf "%s\n" " ${ESC}[97m${ESC}[43m[ DBG ]${ESC}[m${ESC}[90m: ${ESC}[1m${ESC}[4m${ESC}[93m$*${ESC}[m"
}

msg_warn() {
  printf "%s\n" " ${ESC}[93m[ WRN ]${ESC}[90m: ${ESC}[33m$*${ESC}[m" >&2
}

msg_error() {
  printf "%s\n" " ${ESC}[91m[ ERR ]${ESC}[90m: ${ESC}[31m$*${ESC}[m" >&2
}

msg_fatal() {
  printf "%s\n" " ${ESC}[97m${ESC}[41m[ FTL ]${ESC}[m${ESC}[90m: ${ESC}[1m${ESC}[91m$*${ESC}[m" >&2
}

msg_ask() {
  printf "%s" " ${ESC}[33m[ ASK ]${ESC}[90m: ${ESC}[1m${ESC}[97m$*${ESC}[m"
  read -r RET
}
