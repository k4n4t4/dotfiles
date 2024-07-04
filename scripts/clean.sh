clean() {
  if [ $# -ne 0 ]; then
    error "Wrong number of arguments."
    return 1
  fi
  if [ ! -d "$WORK_PATH/files" ]; then
    error "$WORK_PATH/files is not directory"
    return 1
  fi
  set -- "$WORK_PATH/files"
  _find_dirs=""
  while [ $# -gt 0 ]; do
    _temp_dirs=""
    while [ $# -gt 0 ]; do
      for t in "$1"/* "$1"/.*; do
        base_name "$t"
        case "$RET" in
          ( "*" | ".*" | "." | ".." ) continue ;;
          ( * )
            if [ -d "$t" ]; then
              qesc "$t"
              _temp_dirs="$_temp_dirs $RET"
              _find_dirs="$RET $_find_dirs"
            fi
            ;;
        esac
      done
      shift
    done
    eval "set -- $_temp_dirs"
  done
  eval "set -- $_find_dirs"
  while [ $# -gt 0 ]; do
    if is_empty_dir "$1"; then
      _rmdir "$1"
    fi
    shift
  done
}
