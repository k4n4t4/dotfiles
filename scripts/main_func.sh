#!/bin/sh
set -eu

READ_OPTION() {
  for opt in "${@}"; do
    case "${opt}" in
      "--yes" )
        OPTION_YES=true
        ;;
      "--force" )
        OPTION_FORCE=true
        ;;
      "--not-use-nerd-font" )
        OPTION_NOT_USE_NERD_FONT=true
        ;;
      "--uninstall" | "--unlink" )
        OPTION_UNINSTALL=true
        ;;
      -[!-]* )
        for i in $(seq $(( ${#opt} - 1 ))); do
          sopt="$(printf "_${opt}" | cut -c $(( ${i} + 2 )))"
          case "${sopt}" in
            "y" )
              OPTION_YES=true
              ;;
            "f" )
              OPTION_FORCE=true
              ;;
            "n" )
              OPTION_NOT_USE_NERD_FONT=true
              ;;
            "u" )
              OPTION_UNINSTALL=true
              ;;
            "h" )
              OPTION_HELP=true
              ;;
            * )
              OPTION_HELP=true
              ERROR "\"-${sopt}\" is unknown option."
              ;;
          esac
        done
        ;;
      "--help" )
        OPTION_HELP=true
        ;;
      * )
        OPTION_HELP=true
        ERROR "\"${opt}\" is unknown option."
        ;;
    esac
  done
}

CHECK_OS() {
  case "${1}" in
    "Linux" )
      LOG "\"${1}\" is supported."
      ;;
    * )
      ERROR "\"${1}\" is not supported."
      EXIT
      ;;
  esac
}

GET_DISTRO(){
  if [ -f "/etc/os-release" ]; then
    . /etc/os-release
    distro="${NAME}"
  else
    ERROR "\"os-release\" is not found."
    EXIT
  fi
}

CMD_EXIST() {
  for cmd in "${@}"; do
    if type "${cmd}" > /dev/null 2>&1; then
      LOG "\"${cmd}\"\033[37m command is exist."
      eval "${cmd}_exist=true"
    else
      WARN "\"${cmd}\"\033[37m command is not exist."
      eval "${cmd}_exist=false"
    fi
  done
}

createLink() {
  if [ -e "${1}" ]; then
    flag="$(FILE_TYPE "${2}")"
    case "${flag}" in
      "not" )
        linkAdd "${1}" "${2}"
        ;;
      "file" )
        printf "\033[94m\"${2}\" is file. Replace? Delete?\033[m\n"
        if "${OPTION_FORCE}"; then
          Ans="r"
        else
          READ_MSG "Rdc"
          read "Ans"
        fi
        case "${Ans}" in
          [NnCc]* )
            printf "\033[91mCancel\033[m\n"
            ;;
          [YyDd]* )
            fileDel "${2}"
            ;;
          * )
            fileDel "${2}"
            linkAdd "${1}" "${2}"
            ;;
        esac
        ;;
      "symbolic" )
        L="$(readlink -n "${2}")"
        if [ "${L}" = "${1}" ]; then
          printf "\033[32m[OK] \033[33m\"${2}\" is exist.\033[m\n"
        else
          printf "\033[36m\"${2}\" is symbolic. ["
          printf "\"${L}\""
          printf "] Replace? Unlink?\033[m\n"
          if "${OPTION_FORCE}"; then
            Ans="r"
          else
            READ_MSG "Ruc"
            read "Ans"
          fi
          case "${Ans}" in
            [NnCc]* )
              printf "\033[91mCancel\033[m\n"
              ;;
            [YyUu]* )
              linkDel "${2}"
              ;;
            * )
              linkDel "${2}"
              linkAdd "${1}" "${2}"
              ;;
          esac
        fi
        ;;
      "dir" )
        printf "\033[94m\"${2}\" is dir. Replace? Delete?\033[m\n"
        if "${OPTION_FORCE}"; then
          Ans="r"
        else
          READ_MSG "rdC"
          read "Ans"
        fi
        case "${Ans}" in
          [Rr]* )
            dirDel "${2}"
            linkAdd "${1}" "${2}"
            ;;
          [YyDd]* )
            dirDel "${2}"
            ;;
          * )
            printf "\033[91mCancel\033[m\n"
            ;;
        esac
        ;;
      "pipe" )
        ERROR "Error \"${2}\" is pipe"
        EXIT
        ;;
      "socket" )
        ERROR "Error \"${2}\" is socket"
        EXIT
        ;;
      "block" )
        ERROR "Error \"${2}\" is block"
        EXIT
        ;;
      "char" )
        ERROR "Error \"${2}\" is char"
        EXIT
        ;;
      "etc" )
        ERROR "Error in \"createLink\""
        EXIT
        ;;
    esac
  else
    ERROR "${1} is not found!"
    EXIT
  fi
}

createDir() {
  flag="$(FILE_TYPE "${1}")"
  case "${flag}" in
    "not" )
      dirAdd "${1}"
      ;;
    "file" )
      printf "\033[94m\"${1}\" is file. Replace? Delete?\033[m\n"
      if "${OPTION_FORCE}"; then
        Ans="r"
      else
        READ_MSG "Rdc"
        read "Ans"
      fi
      case "${Ans}" in
        [NnCc]* )
          printf "\033[91mCancel\033[m\n"
          ;;
        [YyDd]* )
          fileDel "${1}"
          ;;
        * )
          fileDel "${1}"
          dirAdd "${1}"
          ;;
      esac
      ;;
    "symbolic" )
      L="$(readlink -n "${1}")"
      printf "\033[36m\"${1}\" is symbolic. ["
      printf "\"${L}\""
      printf "] Replace? Unlink?\033[m\n"
      if "${OPTION_FORCE}"; then
        Ans="r"
      else
        READ_MSG "Ruc"
        read "Ans"
      fi
      case "${Ans}" in
        [NnCc]* )
          printf "\033[91mCancel\033[m\n"
          ;;
        [YyUu]* )
          linkDel "${1}"
          ;;
        * )
          linkDel "${1}"
          dirAdd "${1}"
          ;;
      esac
      ;;
    "dir" )
      printf "\033[32m[OK] \033[33m\"${1}\" is exist.\033[m\n"
      ;;
    "pipe" )
      ERROR "Error \"${1}\" is pipe"
      EXIT
      ;;
    "socket" )
      ERROR "Error \"${1}\" is socket"
      EXIT
      ;;
    "block" )
      ERROR "Error \"${1}\" is block"
      EXIT
      ;;
    "char" )
      ERROR "Error \"${1}\" is char"
      EXIT
      ;;
    "etc" )
      ERROR "Error in \"createDir\""
      EXIT
      ;;
  esac
}

LINK() {
  if [ $(( ${#} % 2 )) = 1 ] || [ ${#} = 0 ]; then
    ERROR "Error in \"LINK\""
    EXIT
  fi
  for i in $(seq $(( ${#} / 2 ))); do
    _1="${dotfiles_root}/$(eval "printf \"\${$(( ${i} * 2 - 1 ))}\"")"
    _2="${targetdir_root}/$(eval "printf \"\${$(( ${i} * 2 ))}\"")"
    
    NUM_INC "link_count"
    
    if "${OPTION_UNINSTALL}"; then
      if [ -L "${_2}" ]; then
        linkDel "${_2}"
        NUM_DEC "link_suc_count"
      fi
    else
      createLink "${_1}" "${_2}"
    fi
    sleep 0.01
  done
}

DIR() {
  for name in "${@}"; do
    NUM_INC "dir_count"
    createDir "${targetdir_root}/${name}"
    sleep 0.01
  done
}

