#!/bin/sh
set -eu

read_options() {
  for opt in "$@"; do
    case "$opt" in
      "--help" ) OPTION_HELP=true ;;
      "--force" ) OPTION_FORCE=true ;;
      "--uninstall" ) OPTION_UNINSTALL=true ;;
      --* )
        OPTION_HELP=true
        error "\"${opt}\" is unknown option."
        ;;
      -* )
        for i in $(seq $(( ${#opt} - 1 ))); do
          sopt="$(printf "_${opt}" | cut -c $(( ${i} + 2 )))"
          case "$sopt" in
            "h" ) OPTION_HELP=true ;;
            "f" ) OPTION_FORCE=true ;;
            "u" ) OPTION_UNINSTALL=true ;;
            * )
              OPTION_HELP=true
              error "\"-${sopt}\" is unknown option."
              ;;
          esac
        done
        ;;
    esac
  done
}

check_os() {
  case "${1}" in
    "Linux" )
      log "\"${1}\" is supported."
      ;;
    * )
      STATUS=2
      exit_log "\"${1}\" is not supported."
      ;;
  esac
}

get_distro(){
  if [ -f "/etc/os-release" ]; then
    . /etc/os-release
    DISTRO="${NAME}"
  else
    STATUS=2
    exit_log "\"os-release\" is not found."
  fi
}

cmd_exist() {
  if type "$1" > /dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi
}

exit_log() {
  if [ "$*" != "" ]; then
    printf "$ESC[90m (X) $ESC[m%s$ESC[m\n" "$*"
  fi
  exit $STATUS
}


num_inc() {
  eval "${1}=\$(( \${${1}} + 1 ))"
}

num_dec() {
  eval "${1}=\$(( \${${1}} - 1 ))"
}
