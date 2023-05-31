#!/bin/sh
set -eu

NUM_INC() {
  eval "${1}=\$(( \${${1}} + 1 ))"
}

NUM_DEC() {
  eval "${1}=\$(( \${${1}} - 1 ))"
}

FILE_TYPE() {
  if [ -L "${1}" ]; then
    printf "symbolic"
  elif [ -f "${1}" ]; then
    printf "file"
  elif [ -d "${1}" ]; then
    printf "dir"
  elif [ -p "${1}" ]; then
    printf "pipe"
  elif [ -S "${1}" ]; then
    printf "socket"
  elif [ -b "${1}" ]; then
    printf "block"
  elif [ -c "${1}" ]; then
    printf "char"
  elif [ -e "${1}" ]; then
    printf "etc"
  else
    printf "not"
  fi
}

linkAdd() {
  D="$(dirname "${2}")"
  if [ -d "${D}" ]; then
    printf "\033[32m"
    set -x
    ln -s "${1}" "${2}"
    { set +x; } 2> /dev/null
    printf "\033[m"
    NUM_INC "link_suc_count"
  else
    ERROR "${D} is not found."
    EXIT
  fi
}

linkDel() {
  printf "\033[32m"
  set -x
  unlink "${1}"
  { set +x; } 2> /dev/null
  printf "\033[m"
}

fileDel() {
  printf "\033[32m"
  set -x
  rm -f "${1}"
  { set +x; } 2> /dev/null
  printf "\033[m"
}

dirAdd() {
  printf "\033[32m"
  set -x
  mkdir -p "${1}"
  { set +x; } 2> /dev/null
  printf "\033[m"
  NUM_INC "dir_suc_count"
}

dirDel() {
  printf "\033[32m"
  set -x
  rm -rf "${1}"
  { set +x; } 2> /dev/null
  printf "\033[m"
}

