_move() {
  dir_name "$2"
  if _mkdir "$RET"; then
    if mv -- "$1" "$2"; then
      log "move: \"$1\" --> \"$2\""
      return 0
    fi
    fatal "Could not move \"$1\" to \"$2\""
    return 1
  fi
  return 1
}

_link() {
  dir_name "$2"
  if _mkdir "$RET"; then
    if ln -s -- "$1" "$2"; then
      log "link: \"$1\" --> \"$2\""
      return 0
    fi
    fatal "Could not link \"$1\" to \"$2\""
    return 1
  fi
  return 1
}

_unlink() {
  if unlink -- "$1"; then
    log "unlink: \"$1\""
    return 0
  fi
  fatal "Could not unlink \"$1\""
  return 1
}

_restore_link() {
  RET="${2:-"$(realpath "$1")"}"
  if unlink -- "$1"; then
    if mv -- "$RET" "$1"; then
      log "restore: \"$RET\" to \"$1\""
      return 0
    else
      fatal "Could not move \"$RET\" to \"$1\""
      return 1
    fi
  fi
  fatal "Could not restore \"$1\""
  return 1
}

_del_file() {
  if rm -f -- "$1"; then
    log "rm f: \"$1\""
    return 0
  fi
  fatal "Could not remove file \"$1\""
  return 1
}

_del_r() {
  if rm -rf -- "$1"; then
    log "rm rf: \"$1\""
    return 0
  fi
  fatal "Could not remove \"$1\""
  return 1
}

_rmdir() {
  if rmdir -- "$1"; then
    log "rmdir: \"$1\""
    return 0
  fi
  fatal "Could not remove \"$1\""
  return 1
}

_mkdir() {
  if [ ! -d "$1" ]; then
    if file_exist "$1"; then
      error "Already Exist: \"$1\""
      return 1
    fi
    if mkdir -p -- "$1"; then
      log "mkdir: \"$1\""
      return 0
    fi
    fatal "Could not make directory \"$1\""
    return 1
  fi
  return 0
}

_mkfile() {
  dir_name "$1"
  if _mkdir "$RET"; then
    if [ ! -f "$1" ]; then
      if file_exist "$1"; then
        error "Already Exist: \"$1\""
        return 1
      fi
      if touch -- "$1"; then
        log "mkfile: \"$1\""
        return 0
      fi
      fatal "Could not make file \"$1\""
      return 1
    fi
    return 0
  fi
  return 1
}

# 1 target
# 2 origin
# 3 solved
# 4 isforce?
_store() {
  set -- "$1" "$2" "${3:-"$(realpath "$1")"}" "${4:-false}"
  if [ -L "$1" ] && [ -e "$2" ] && [ "$3" = "$2" ]; then
    info "Already managed."
  else
    [ -L "$1" ] && _restore_link "$1" "$3"
    if file_exist "$2"; then
      if $4; then
        _del_r "$2"
      else
        error "\"$2\" is already in use."
        ask "Replace? [y/N]: "
        case "$RET" in
          ( [Yy] )
            _del_r "$2"
            ;;
          ( * )
            log "Canceled."
            return 0
            ;;
        esac
      fi
    fi
    _move "$1" "$2"
    _link "$2" "$1"
  fi
}

# 1 target
# 2 origin
# 3 depth
# 4 isforce?
_store_recursive() {
  _target="$1"
  _origin="$2"
  _counter="$3"
  _opt_force="${4:-false}"

  set -- "$_target"
  while [ "$_counter" -gt 0 ] && [ $# -gt 0 ]; do
    _counter=$((_counter - 1))
    _temp_dirs=""
    while [ $# -gt 0 ]; do
      for t in "$1"/* "$1"/.*; do
        base_name "$t"
        case "$RET" in
          ( "*" | ".*" | "." | ".." ) continue ;;
          ( * )
            if [ ! -e "$t" ]; then
              error "File Not Found: \"$t\""
              [ -L "$t" ] && info "File is broken symlink."
              return 1
            fi
            t_s="$t"
            [ -L "$t" ] && t_s="$(realpath "$t")"
            path_without "$t" "$_target"
            o="$_origin/$RET"
            if [ "$_counter" -gt 0 ] && [ -d "$t" ]; then
              [ -L "$t" ] && _restore_link "$t" "$t_s"
              qesc "$t"
              _temp_dirs="$_temp_dirs $RET"
            else
              _store "$t" "$o" "$t_s" "$_opt_force"
            fi
            ;;
        esac
      done
      shift
    done
    eval "set -- $_temp_dirs"
  done
}

# 1 target
# 2 origin
# 3 solved
_restore() {
  set -- "$1" "$2" "${3:-"$(realpath "$1")"}"
  if [ -L "$1" ] && [ -e "$2" ] && [ "$3" = "$2" ]; then
    info "Already managed."
    _restore_link "$1" "$2"
  else
    info "\"$1\" is not managed."
  fi
}

# 1 target
# 2 origin
# 3 depth
_restore_recursive() {
  _target="$1"
  _origin="$2"
  _counter="$3"

  set -- "$_target"
  while [ "$_counter" -gt 0 ] && [ $# -gt 0 ]; do
    _counter=$((_counter - 1))
    _temp_dirs=""
    while [ $# -gt 0 ]; do
      for t in "$1"/* "$1"/.*; do
        base_name "$t"
        case "$RET" in
          ( "*" | ".*" | "." | ".." ) continue ;;
          ( * )
            if [ ! -e "$t" ]; then
              error "File Not Found: \"$t\""
              [ -L "$t" ] && info "File is broken symlink."
              return 1
            fi
            t_s="$t"
            [ -L "$t" ] && t_s="$(realpath "$t")"
            path_without "$t" "$_target"
            o="$_origin/$RET"
            if [ $_counter -gt 0 ] && [ -d "$t" ]; then
              [ -L "$t" ] && _restore_link "$t" "$t_s"
              qesc "$t"
              _temp_dirs="$_temp_dirs $RET"
            else
              _restore "$t" "$o" "$t_s"
            fi
            ;;
        esac
      done
      shift
    done
    eval "set -- $_temp_dirs"
  done
}

# 1 origin
# 2 target
# 3 solved
# 4 isforce?
_install_link() {
  set -- "$1" "$2" "${3:-"$(realpath "$2")"}" "${4:-false}"
  case "$3" in
    ( "$1" )
      info "\"$2\" is managed."
      ;;
    ( * )
      if file_exist "$2"; then
        if $4; then
          if [ -L "$2" ]; then
            _unlink "$2"
          else
            _del_r "$2"
          fi
        else
          error "\"$2\" is already in use."
          ask "Replace? [y/N]: "
          case "$RET" in
            ( [Yy] )
              if [ -L "$2" ]; then
                _unlink "$2"
              else
                _del_r "$2"
              fi
              ;;
            ( * )
              log "Canceled."
              return 0
              ;;
          esac
        fi
      fi
      _link "$1" "$2"
      ;;
  esac
}

# 1 origin
# 2 target
# 3 depth
# 4 isforce?
_install_link_recursive() {
  _origin="$1"
  _target="$2"
  _counter="$3"
  _opt_force="${4:-false}"

  set -- "$_origin"
  while [ "$_counter" -gt 0 ] && [ $# -gt 0 ]; do
    _counter=$((_counter - 1))
    _temp_dirs=""
    while [ $# -gt 0 ]; do
      for o in "$1"/* "$1"/.*; do
        base_name "$o"
        case "$RET" in
          ( "*" | ".*" | "." | ".." ) continue ;;
          ( * )
            if [ ! -e "$o" ]; then
              error "File Not Found: \"$o\""
              [ -L "$o" ] && info "File is broken symlink."
              return 1
            fi
            path_without "$o" "$_origin"
            t="$_target/$RET"
            if [ -L "$t" ]; then
              t_s="$(realpath "$t")"
            else
              t_s="$t"
            fi
            if [ $_counter -gt 0 ] && [ -d "$o" ]; then
              qesc "$o"
              _temp_dirs="$_temp_dirs $RET"
            else
              _install_link "$o" "$t" "$t_s" "$_opt_force"
            fi
            ;;
        esac
      done
      shift
    done
    eval "set -- $_temp_dirs"
  done
}


# 1 origin
# 2 target
# 3 solved
_uninstall_unlink() {
  set -- "$1" "$2" "${3:-"$(realpath "$2")"}"
  case "$3" in
    ( "$1" )
      info "\"$2\" is managed."
      _unlink "$2"
      ;;
    ( * )
      info "\"$2\" is not managed."
      ;;
  esac
}

# 1 origin
# 2 target
# 3 depth
_uninstall_unlink_recursive() {
  _origin="$1"
  _target="$2"
  _counter="$3"

  set -- "$_origin"
  while [ "$_counter" -gt 0 ] && [ $# -gt 0 ]; do
    _counter=$((_counter - 1))
    _temp_dirs=""
    while [ $# -gt 0 ]; do
      for o in "$1"/* "$1"/.*; do
        base_name "$o"
        case "$RET" in
          ( "*" | ".*" | "." | ".." ) continue ;;
          ( * )
            if [ ! -e "$o" ]; then
              error "File Not Found: \"$o\""
              [ -L "$o" ] && info "File is broken symlink."
              return 1
            fi
            path_without "$o" "$_origin"
            t="$_target/$RET"
            if [ -L "$t" ]; then
              t_s="$(realpath "$t")"
            else
              t_s="$t"
            fi
            if [ $_counter -gt 0 ] && [ -d "$o" ]; then
              qesc "$o"
              _temp_dirs="$_temp_dirs $RET"
            else
              _uninstall_unlink "$o" "$t" "$t_s"
            fi
            ;;
        esac
      done
      shift
    done
    eval "set -- $_temp_dirs"
  done
}


# 1 origin
# 2 target
# 3 solved
_verify_check() {
  set -- "$1" "$2" "${3:-"$(realpath "$2")"}"
  case "$3" in
    ( "$1" )
      info "\"$2\" is managed."
      ;;
    ( * )
      info "\"$2\" is not managed."
      ;;
  esac
}

# 1 origin
# 2 target
# 3 depth
_verify_check_recursive() {
  _origin="$1"
  _target="$2"
  _counter="$3"

  set -- "$_origin"
  while [ "$_counter" -gt 0 ] && [ $# -gt 0 ]; do
    _counter=$((_counter - 1))
    _temp_dirs=""
    while [ $# -gt 0 ]; do
      for o in "$1"/* "$1"/.*; do
        base_name "$o"
        case "$RET" in
          ( "*" | ".*" | "." | ".." ) continue ;;
          ( * )
            if [ ! -e "$o" ]; then
              error "File Not Found: \"$o\""
              [ -L "$o" ] && info "File is broken symlink."
              return 1
            fi
            path_without "$o" "$_origin"
            t="$_target/$RET"
            if [ -L "$t" ]; then
              t_s="$(realpath "$t")"
            else
              t_s="$t"
            fi
            if [ $_counter -gt 0 ] && [ -d "$o" ]; then
              qesc "$o"
              _temp_dirs="$_temp_dirs $RET"
            else
              _verify_check "$o" "$t" "$t_s"
            fi
            ;;
        esac
      done
      shift
    done
    eval "set -- $_temp_dirs"
  done
}
