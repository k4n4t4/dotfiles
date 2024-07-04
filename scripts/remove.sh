# $1 = "links file name"
remove() {
  if [ $# -eq 1 ]; then
    opt_linksFilePath="$WORK_PATH/links/$1.links"
  else
    error "Invalid Argument!"
    return 1
  fi
  if [ -f "$opt_linksFilePath" ]; then
    ask "Remove \"$1\"? [y/N]: "
    case "$RET" in
      ( [yY] )
        _del_file "$opt_linksFilePath"
        ;;
      ( * )
        log "Canceled."
        return 1
    esac
  elif file_exist "$opt_linksFilePath"; then
    error "Can not remove \"$opt_linksFilePath\""
    return 1
  fi
}
