install() {
  opt_linksFilePath="$WORK_PATH/links/default.links"
  if [ $# -eq 1 ]; then
    opt_linksFilePath="$WORK_PATH/links/$1.links"
  fi
  if [ ! -e "$opt_linksFilePath" ]; then
    error "\"$opt_linksFilePath\" is not found."
    return 1
  fi

  dot() {
    _install "$@"
  }

  . "$opt_linksFilePath"
}
