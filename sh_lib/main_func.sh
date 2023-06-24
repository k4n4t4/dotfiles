#!/bin/sh
set -eu

add_link() {
  dir="$(dirname "$2")"
  if ! [ -d "$dir" ]; then
    add_dir "$dir"
  fi
  ln -s "$1" "$2"
  success "ln -s: \"$1\" ---> \"$2\""
}

add_dir() {
  mkdir -p "$1"
  success "mkdir -p: \"$1\""
}

del_link() {
  unlink "$1"
  success "unlink: \"$1\""
}

del_file() {
  rm -f "$1"
  success "rm -f: \"$1\""
}

del_dir() {
  rm -rf "$1"
  success "rm -rf: \"$1\""
}

read_link_list_arg() {
  if ! $OPTION_UNINSTALL ; then
    add_link_check "$DOTFILES_DIR/files/$1" "$HOME_DIR/${2:-$1}"
  else
    del_link_check "$DOTFILES_DIR/files/$1" "$HOME_DIR/${2:-$1}"
  fi
}

read_link_list() {
  for arg in "$@" ; do
    while read line ; do
      eval "read_link_list_arg $line"
    done < "$arg"
  done
}

add_link_check() {
  if [ -e "$1" ]; then
    if [ -e "$2" ] || [ -L "$2" ]; then
      if [ -L "$2" ]; then
        target="$(readlink -n "$2")"
        if [ "$1" = "$target" ]; then
          success "\"$2\" is already installed."
        else
          warn "\"$2\" (\"$target\") is already exists and it is symbolic."
          if $OPTION_FORCE ; then
            del_link "$2"
            add_link "$1" "$2"
          else
            info "Replace Symbolic?"
            read -p "[$ESC[92mY$ESC[m/$ESC[91mn$ESC[m]: " Ans < /dev/tty
            case "$Ans" in
              [nN]* )
                log "Skip Symbolic."
                ;;
              * )
                del_link "$2"
                add_link "$1" "$2"
                ;;
            esac
          fi
        fi
      elif [ -f "$2" ]; then
        warn "\"$2\" is already exists."
        if $OPTION_FORCE ; then
          del_file "$2"
          add_link "$1" "$2"
        else
          info "Replace File?"
          read -p "[$ESC[92mY$ESC[m/$ESC[91mn$ESC[m]: " Ans < /dev/tty
          case "$Ans" in
            [nN]* )
              log "Skip File."
              ;;
            * )
              del_file "$2"
              add_link "$1" "$2"
              ;;
          esac
        fi
      elif [ -d "$2" ]; then
        warn "\"$2\" is already exists and it is dir."
        if $OPTION_FORCE ; then
          del_dir "$2"
          add_link "$1" "$2"
        else
          info "Replace Dir?"
          read -p "[$ESC[92my$ESC[m/$ESC[91mN$ESC[m]: " Ans < /dev/tty
          case "$Ans" in
            [yY]* )
              del_dir "$2"
              add_link "$1" "$2"
              ;;
            * )
              log "Skip Dir."
              ;;
          esac
        fi
      else
        error "Unsupported file: \"$2\""
      fi
    else
      add_link "$1" "$2"
    fi
  else
    error "Did not find file: \"$1\""
  fi
}

del_link_check() {
  if [ -e "$2" ] || [ -L "$2" ]; then
    if [ -L "$2" ] && [ "$1" = "$(readlink -n "$2")" ]; then
      del_link "$2"
    else
      error "Unsupported file: \"$2\""
    fi
  else
    success "Did not find symbolic: \"$2\""
  fi
}

