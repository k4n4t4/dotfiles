log() {
  printf "%s\n" " ${ESC}[32m[ LOG ]${ESC}[90m: ${ESC}[m$*"
}

success() {
  printf "%s\n" " ${ESC}[92m[ SUC ]${ESC}[90m: ${ESC}[32m$*${ESC}[m"
}

info() {
  printf "%s\n" " ${ESC}[94m[ INF ]${ESC}[90m: ${ESC}[4m${ESC}[34m$*${ESC}[m"
}

debug() {
  printf "%s\n" " ${ESC}[97m${ESC}[43m[ DBG ]${ESC}[m${ESC}[90m: ${ESC}[1m${ESC}[4m${ESC}[93m$*${ESC}[m"
}

warn() {
  printf "%s\n" " ${ESC}[93m[ WRN ]${ESC}[90m: ${ESC}[33m$*${ESC}[m" >&2
}

error() {
  printf "%s\n" " ${ESC}[91m[ ERR ]${ESC}[90m: ${ESC}[31m$*${ESC}[m" >&2
}

fatal() {
  printf "%s\n" " ${ESC}[97m${ESC}[41m[ FTL ]${ESC}[m${ESC}[90m: ${ESC}[1m${ESC}[91m$*${ESC}[m" >&2
}

ask() {
  printf "%s" " ${ESC}[33m[ ASK ]${ESC}[90m: ${ESC}[1m${ESC}[97m$*${ESC}[m"
  read RET
}
