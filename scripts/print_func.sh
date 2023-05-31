#!/bin/sh
set -eu

DOTFILES_BANNER() {
  printf "\n\033[96m"
cat << EOF
         ██              ██          ████  ██  ██                      
     ██████    ████    ████████    ██▓▓▓  ▓▓  ▓██    ████      ██████  
   ██▓▓▓▓██  ██▓▓▓ ██ ▓▓▓██▓▓▓   ████████  ██ ▓██  ████████  ████▓▓▓   
  ▓██   ▓██ ▓██   ▓██   ▓██     ▓▓▓██▓▓▓  ▓██ ▓██ ▓██▓▓▓▓▓  ▓▓▓▓ ████  
  ▓▓ ██████ ▓▓ ████▓    ▓▓ ████   ▓██     ▓██ ▓██ ▓▓ ██████  ██████▓   
    ▓▓▓▓▓▓    ▓▓▓▓        ▓▓▓▓    ▓▓      ▓▓  ▓▓    ▓▓▓▓▓▓  ▓▓▓▓▓▓     
EOF
  printf "\033[m\n"
}

PRINT_HELP() {
  printf " \033[35m-h\033[m, \033[35m--help\033[m                   \033[37m display this help.\033[m\n"
  printf " \033[35m-y\033[m, \033[35m--yes\033[m                    \033[37m yes!\033[m              \n"
  printf " \033[35m-f\033[m, \033[35m--force\033[m                  \033[37m force replace.\033[m    \n"
  printf " \033[35m-n\033[m, \033[35m--not-use-nerd-font\033[m      \033[37m not use nerd font.\033[m\n"
  printf " \033[35m-u\033[m, \033[35m--uninstall\033[m, \033[35m--unlink    \033[37m unlink.\033[m           \n"
}

TITLE() {
  NUMBER_OF_SPACE=$(( ${COLUMNS} - ${#1} - 2 ))
  NUMBER_OF_SPACE_1=$(( ${NUMBER_OF_SPACE} / 2 ))
  NUMBER_OF_SPACE_2=$(( ${NUMBER_OF_SPACE} - ${NUMBER_OF_SPACE_1} ))
  printf "\033[97m\033[100m"
  printf "["
  printf " %0.s" $(seq ${NUMBER_OF_SPACE_1})
  printf "${1}"
  printf " %0.s" $(seq ${NUMBER_OF_SPACE_2})
  printf "]"
  printf "\033[m\n"
}

EXIT() {
  TITLE "exit"
  exit ${STATUS}
}

LOG() {
  printf "\033[92m(LOG)\033[97m ${*}\033[m\n"
}

INFO() {
  printf "\033[96m(INFO)\033[97m ${*}\033[m\n"
}

WARN() {
  printf "\033[93m(WARN)\033[97m ${*}\033[m\n"
}

ERROR() {
  STATUS=1
  printf "\033[91m(ERR)\033[97m ${*}\033[m\n"
}

PRINT_VARIABLES() {
  
  MAX_LEN=0
  
  for arg in "${@}"; do
    if [ ${#arg} -gt ${MAX_LEN} ]; then
      MAX_LEN=${#arg}
    fi
  done
  
  for arg in "${@}"; do
    printf "\033[95m"
    printf "\${${arg}}"
    printf "\033[37m"
    
    SPACE=$(( ${MAX_LEN} - ${#arg} + 1 ))
    printf " %0.s" $(seq ${SPACE})
    printf "= "
    
    printf "\033[97m"
    printf "\"$(eval "printf \"\${${arg}}\"")\""
    printf "\033[m\n"
  done
}

READ_MSG() {
  if [ "${1}" = "yN" ]; then
    printf "\033[97m[\033[92my\033[37m/\033[91mN\033[97m]: \033[m"
  elif [ "${1}" = "Yn" ]; then
    printf "\033[97m[\033[92mY\033[37m/\033[91mn\033[97m]: \033[m"
  elif [ "${1}" = "Ruc" ]; then
    printf "\033[97m[\033[92mR\033[37m/\033[93mu\033[37m/\033[91mc\033[97m]: \033[m"
  elif [ "${1}" = "Rdc" ]; then
    printf "\033[97m[\033[92mR\033[37m/\033[93md\033[37m/\033[91mc\033[97m]: \033[m"
  elif [ "${1}" = "rdC" ]; then
    printf "\033[97m[\033[92mr\033[37m/\033[93md\033[37m/\033[91mC\033[97m]: \033[m"
  else
    printf "?"
  fi
}
