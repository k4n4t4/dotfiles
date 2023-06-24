#!/bin/sh
set -eu

usage() {
cat << EOF

  Usage:
    $0 [options]

  Options:
    -h, --help      : show help
    -f, --force     : force install
    -u, --uninstall : uninstall

EOF
}

dotfiles_banner() {
  printf "\n$ESC[36m"
cat << EOF
         ██              ██          ████  ██  ██                      
     ██████    ████    ████████    ██▓▓▓  ▓▓  ▓██    ████      ██████  
   ██▓▓▓▓██  ██▓▓▓ ██ ▓▓▓██▓▓▓   ████████  ██ ▓██  ████████  ████▓▓▓   
  ▓██   ▓██ ▓██   ▓██   ▓██     ▓▓▓██▓▓▓  ▓██ ▓██ ▓██▓▓▓▓▓  ▓▓▓▓ ████  
  ▓▓ ██████ ▓▓ ████▓    ▓▓ ████   ▓██     ▓██ ▓██ ▓▓ ██████  ██████▓   
    ▓▓▓▓▓▓    ▓▓▓▓        ▓▓▓▓    ▓▓      ▓▓  ▓▓    ▓▓▓▓▓▓  ▓▓▓▓▓▓     
EOF
  printf "$ESC[m\n"
}

log() {
  printf "$ESC[97m (L) $ESC[m%s$ESC[m\n" "$*"
}

info() {
  printf "$ESC[96m (I) $ESC[m%s$ESC[m\n" "$*"
}

success() {
  printf "$ESC[92m (S) $ESC[m%s$ESC[m\n" "$*"
}

warn() {
  printf "$ESC[93m (W) $ESC[m%s$ESC[m\n" "$*"
}

error() {
  STATUS=1
  printf "$ESC[91m (E) $ESC[m%s$ESC[m\n" "$*"
}

unknown() {
  STATUS=1
  printf "$ESC[95m (U) $ESC[m%s$ESC[m\n" "$*"
}

print_variables() {
  MAX_LEN=0
  for arg in "${@}"; do
    if [ ${#arg} -gt ${MAX_LEN} ]; then
      MAX_LEN=${#arg}
    fi
  done
  for arg in "${@}"; do
    SPACE=$(( ${MAX_LEN} - ${#arg} + 1 ))
    log "$ESC[95m\${${arg}}$ESC[37m$(printf " %0.s" $(seq ${SPACE}))= $ESC[97m\"$(eval "printf \"\${${arg}}\"")\""
  done
}

print_cmd_exist() {
  for cmd in "${@}"; do
    if cmd_exist "$cmd"; then
      log "\"$ESC[32m${cmd}$ESC[m\" command is exist."
    else
      warn "\"$ESC[32m${cmd}$ESC[m\" command is not exist."
    fi
  done
}
