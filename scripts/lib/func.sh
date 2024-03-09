usage() {
if [ $# -eq 0 ]; then
cat << EOL
$ESC[m
Usage$ESC[90m:
  $ESC[32m$0 [cmd] [opt]
$ESC[m
Options$ESC[90m:
  $ESC[32m--help, -h     help
$ESC[m
Commands$ESC[90m:
  $ESC[32minstall, uninstall, check
$ESC[m
EOL
else
  case "$1" in
    install )
cat << EOL
$ESC[m
Usage$ESC[90m:
  $ESC[32m$0 install [opt]
$ESC[m
Options$ESC[90m:
  $ESC[32m--help, -h     help
  $ESC[32m--force, -f    force
$ESC[m
EOL
      ;;
    uninstall )
cat << EOL
$ESC[m
Usage$ESC[90m:
  $ESC[32m$0 uninstall [opt]
$ESC[m
Options$ESC[90m:
  $ESC[32m--help, -h     help
  $ESC[32m--force, -f    force
$ESC[m
EOL
      ;;
    check )
cat << EOL
$ESC[m
Usage$ESC[90m:
  $ESC[32m$0 check [opt]
$ESC[m
Options$ESC[90m:
  $ESC[32m--help, -h     help
$ESC[m
EOL
      ;;
    * )
      error "Unknown Mode"
      exit 8
      ;;
  esac
fi
}

print_banner() {
  if [ $COLUMNS -gt 49 ]; then
    printf "$ESC[m"
cat << EOL
$ESC[38;2;050;100;200m ▄▄▄▄   ▄▄▄  ▄▄▄▄▄ ▄▄▄▄▄ ▄▄▄▄▄ ▄     ▄▄▄▄▄  ▄▄▄  
$ESC[38;2;100;100;200m █   █ █   █   █   █       █   █     █     █   ▀ 
$ESC[38;2;150;100;200m █   █ █   █   █   █▀▀▀    █   █     █▀▀▀   ▀▀▀▄ 
$ESC[38;2;200;100;200m █▄▄▄▀ ▀▄▄▄▀   █   █     ▄▄█▄▄ █▄▄▄▄ █▄▄▄▄ ▀▄▄▄▀ 
EOL
    printf "$ESC[m"
  else
    echo " DOTFILES "
  fi
}

log() {
  printf " $ESC[90m[$ESC[37mL$ESC[90m] $ESC[m%s$ESC[m\n" "$*"
}
info() {
  printf " $ESC[90m[$ESC[36mI$ESC[90m] $ESC[m%s$ESC[m\n" "$*"
}
success() {
  printf " $ESC[90m[$ESC[32mS$ESC[90m] $ESC[m%s$ESC[m\n" "$*"
}
warn() {
  printf " $ESC[90m[$ESC[33mW$ESC[90m] $ESC[m%s$ESC[m\n" "$*"
}
error() {
  printf " $ESC[90m[$ESC[31mE$ESC[90m] $ESC[m%s$ESC[m\n" "$*"
}
unknown() {
  printf " $ESC[90m[$ESC[35mU$ESC[90m] $ESC[m%s$ESC[m\n" "$*"
}



add_link() {
  dir="`dirname "$2"`"
  if [ ! -d "$dir" ]; then
    mkdir -p "$dir"
    success "mk dir: \"$dir\""
  fi
  ln -s "$1" "$2"
  success "mk link: \"$1\" ---> \"$2\""
}
del_link() {
  unlink "$1"
  success "rm link: \"$1\""
}
del_file() {
  rm -f "$1"
  success "rm file: \"$1\""
}
del_dir() {
  rm -rf "$1"
  success "rm dir: \"$1\""
}


dot() {
  first_path=""
  second_path=""
  
  opt_recursive=false
  
  mode_opt_install=true
  mode_opt_uninstall=true
  mode_opt_check=true
  mode_opt_need_reset=true
  
  reset_mode_opt() {
    mode_opt_install=false
    mode_opt_uninstall=false
    mode_opt_check=false
    mode_opt_need_reset=false
  }
  
  for opt in "$@"; do
    opt="`echo $opt`"
    if [ ${#opt} -ne 0 ]; then
      case "$opt" in
        --install | -i )
          if $mode_opt_need_reset; then
            reset_mode_opt
          fi
          mode_opt_install=true
          ;;
        --uninstall | -u )
          if $mode_opt_need_reset; then
            reset_mode_opt
          fi
          mode_opt_uninstall=true
          ;;
        --check | -c )
          if $mode_opt_need_reset; then
            reset_mode_opt
          fi
          mode_opt_check=true
          ;;
        --recursive | -r )
          opt_recursive=true
          ;;
        -* )
          _opt="`echo "$opt" | cut -c 2-`"
          for i in `seq ${#_opt}`; do
            o="`echo $_opt | cut -c $i`"
            case "$o" in
              i )
                if $mode_opt_need_reset; then
                  reset_mode_opt
                fi
                mode_opt_install=true
                ;;
              u )
                if $mode_opt_need_reset; then
                  reset_mode_opt
                fi
                mode_opt_uninstall=true
                ;;
              c )
                if $mode_opt_need_reset; then
                  reset_mode_opt
                fi
                mode_opt_check=true
                ;;
              r )
                opt_recursive=true
                ;;
              * )
                error "invalid argument"
                info "dot : $*"
                exit 7
                ;;
            esac
          done
          ;;
        * )
          if [ "$first_path" = "" ]; then
            first_path="$opt"
          elif [ "$second_path" = "" ]; then
            second_path="$opt"
          else
            error "invalid argument"
            info "dot : $*"
            exit 6
          fi
          ;;
      esac
    fi
  done
  if [ "$first_path" = "" ]; then
    error "invalid argument"
    info "dot : $*"
    exit 6
  elif [ "$second_path" = "" ]; then
    second_path="$first_path"
  fi
  
  [ $mode_opt_install = false -a "$mode" = "install" ] && return 0
  [ $mode_opt_uninstall = false -a "$mode" = "uninstall" ] && return 0
  [ $mode_opt_check = false -a "$mode" = "check" ] && return 0
  
  first_full_path="$DOTFILES_DIR/files/$first_path"
  second_full_path="$TARGET_DIR/$second_path"
  
  if $opt_recursive; then
    if [ ! -d "$first_full_path" ]; then
      error "\"$first_full_path\" is not dir."
      exit 10
    else
      for file in "$first_full_path"/*; do
        push first_path second_path
        file_basename="`basename "$file"`"
        _first_path="$first_path/$file_basename"
        _second_path="$second_path/$file_basename"
        _first_full_path="$DOTFILES_DIR/files/$_first_path"
        _second_full_path="$TARGET_DIR/$_second_path"
        if [ -d "$_first_full_path" ]; then
          dot "$_first_path" "$_second_path" -r
        else
          dot "$_first_path" "$_second_path"
        fi
        pop first_path second_path
      done
      return
    fi
  fi
  
  if [ "$mode" = "check" ]; then
    check "$first_full_path" "$second_full_path"
  elif [ "$mode" = "install" ]; then
    install "$first_full_path" "$second_full_path"
  elif [ "$mode" = "uninstall" ]; then
    uninstall "$first_full_path" "$second_full_path"
  fi
  
}

_check_count=0
check() {
  if [ ! -e "$1" ]; then
    error "\"$1\" is not found."
    exit 100
  elif [ -e "$2" -o -L "$2" ]; then
    if [ -L "$2" ]; then
      _link="`readlink -n "$2"`"
      if [ "$1" = "$_link" ]; then
        success "\"$2\" is installed."
      else
        warn "\"$2\" is unknown symlink."
      fi
    else
      warn "\"$2\" is not symlink."
    fi
  else
    warn "\"$2\" is not found."
  fi
  _check_count="`expr $_check_count + 1`"
}

_install_count=0
install() {
  if [ ! -e "$1" ]; then
    error "\"$1\" is not found."
    exit 100
  elif [ -e "$2" -o -L "$2" ]; then
    if [ -L "$2" ]; then
      _link="`readlink -n "$2"`"
      if [ "$1" = "$_link" ]; then
        success "\"$2\" is already installed."
      else
        warn "\"$2\" is already exist."
        info "\"$2\" is symlink."
        printf "Overwrite? [y/n]: "
        if $opt_force; then
          _KEY="y"
        else
          _KEY="`get_key`"
        fi
        if [ "$_KEY" = "y" ]; then
          echo "OVERWRITE!"
          del_link "$2"
          add_link "$1" "$2"
        else
          echo "SKIP!"
        fi
      fi
    elif [ -f "$2" ]; then
      warn "\"$2\" is already exist."
      info "\"$2\" is file."
      printf "Overwrite? [y/n]: "
      if $opt_force; then
        _KEY="y"
      else
        _KEY="`get_key`"
      fi
      if [ "$_KEY" = "y" ]; then
        echo "OVERWRITE!"
        del_file "$2"
        add_link "$1" "$2"
      else
        echo "SKIP!"
      fi
    elif [ -d "$2" ]; then
      warn "\"$2\" is already exist."
      info "\"$2\" is dir."
      printf "Overwrite? [y/n]: "
      if $opt_force; then
        _KEY="y"
      else
        _KEY="`get_key`"
      fi
      if [ "$_KEY" = "y" ]; then
        echo "OVERWRITE!"
        del_dir "$2"
        add_link "$1" "$2"
      else
        echo "SKIP!"
      fi
    else
      warn "\"$2\" is already exist."
      info "\"$2\" is not file or dir or symlink."
      info " < SKIPPED > "
    fi
  else
    add_link "$1" "$2"
  fi
  _install_count="`expr $_install_count + 1`"
}

_uninstall_count=0
uninstall() {
  if [ ! -e "$1" ]; then
    error "\"$1\" is not found."
    exit 100
  elif [ -e "$2" -o -L "$2" ]; then
    if [ -L "$2" ]; then
      _link="`readlink -n "$2"`"
      if [ "$1" = "$_link" ]; then
        del_link "$2"
      else
        warn "\"$2\" is unknown symlink."
      fi
    else
      warn "\"$2\" is not symlink."
    fi
  else
    success "\"$2\" is already uninstalled."
  fi
  _uninstall_count="`expr $_uninstall_count + 1`"
}

