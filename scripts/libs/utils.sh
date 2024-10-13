
# shellcheck disable=all

ESC="$(printf "\033")"

is_empty_dir() {
  set -- "${1:-.}"
  set -- "$1/"* "$1/."*
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
        set -- "$1${RET%%"'"*}'\"'\"'"
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
  _option_has_arg=""
  while [ $# -gt 0 ]; do
    case "$1" in
      ( "--" )
        shift
        break
        ;;
      ( ?*":"?* )
        qesc "$1"
        _option_has_arg="$_option_has_arg $RET"
        shift
        ;;
      ( * )
        _variable_name="$1"
        shift
        ;;
    esac
  done
  _normal_args=""
  _option_args=""
  _scan_option=true
  while [ $# -gt 0 ]; do
    if $_scan_option; then
      case "$1" in ( "-"?* )
        case "$1" in
          ( "--" )
            _scan_option=false
            shift
            ;;
          ( "--"* | "-"? )
            case "$1" in ( "--"?*"="* )
              _opt_name="${1%%"="*}"
              _opt_val="${1#*"="}"
              shift
              set -- "$_opt_name" "$_opt_val" "$@"
              continue
            esac
            opt_parser_get_arg_count "$1" "$_option_has_arg"
            _arg_count="$RET"
            if [ $# -gt "$_arg_count" ]; then
              qesc "$1"
              _option_args="$_option_args $RET"
              shift
              while [ "$_arg_count" -gt 0 ]; do
                qesc "$1"
                _option_args="$_option_args $RET"
                shift
                _arg_count=$((_arg_count - 1))
              done
            else
              : error point
              shift
            fi
            ;;
          ( * )
            _multi_short_opt="${1#?}"
            while [ "$_multi_short_opt" != "" ]; do
              s="-${_multi_short_opt%"${_multi_short_opt#?}"*}"
              _multi_short_opt="${_multi_short_opt#?}"
              case "$s" in
                ( "--" ) : ;;
                ( * )
                  opt_parser_get_arg_count "$s" "$_option_has_arg"
                  _arg_count="$RET"
                  if [ "$_arg_count" -ne 0 ]; then
                    : error point
                  else
                    qesc "$s"
                    _option_args="$_option_args $RET"
                  fi
                  ;;
              esac
            done
            shift
            ;;
        esac
        continue
      esac
    fi
    qesc "$1"
    _normal_args="$_normal_args $RET"
    shift
  done
  _normal_args="${_normal_args#" "}"
  _option_args="${_option_args#" "}"
  RET="${_option_args} '--' ${_normal_args}"
  if [ "${_variable_name:-}" != "" ]; then
    eval "$_variable_name"'="$RET"'
  fi
}
