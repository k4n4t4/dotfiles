get_cursor_pos() {
  exec < /dev/tty
  old="`stty -g`"
  trap 'stty "$old"' 1 2 3 15
  stty raw -echo
  printf "\033[6n" > /dev/tty
  pos="`dd count=1 2> /dev/null`"
  stty "$old"
  printf "$pos" | cut -c 3- | tr -d -- "R"
}

get_size() {
  printf "\033[s\033[?25l\033[999B\033[999C" > /dev/tty
  far_pos=`get_cursor_pos`
  printf "\033[u\033[?25h" > /dev/tty
  printf "$far_pos"
}

get_key() {
  exec < /dev/tty
  old="`stty -g`"
  trap 'stty "$old"; exit 1' 1 2 3 9 15
  stty raw -echo -icanon
  printf "`dd count=${1:-1} 2>/dev/null`"
  stty "$old"
}

get_distro() {
  if [ -f "/etc/os-release" ]; then
    . /etc/os-release
    if [ "${NAME:-}" != "" ]; then
      echo "$NAME"
    else
      echo "Unknown"
    fi
  else
    echo "Unknown"
  fi
}

cmd_exist() {
  if type "$1" > /dev/null 2>&1 ; then
    return 0
  else
    return 1
  fi
}


push() {
  for arg in "$@"; do
    if eval "[ \"\${stack_${arg}_index:-}\" = \"\" ]"; then
      eval "stack_${arg}_index=0"
    else
      eval "stack_${arg}_index=\`expr \$stack_${arg}_index + 1\`" || :
    fi
    eval "__stack_index=\$stack_${arg}_index"
    eval "stack_${arg}_$__stack_index=\${${arg}:-}"
  done
}
pop() {
  for arg in "$@"; do
    eval "__stack_index=\$stack_${arg}_index"
    eval "${arg}=\$stack_${arg}_$__stack_index"
    eval "stack_${arg}_index=\`expr \$stack_${arg}_index - 1\`" || :
  done
}
