# $1 = "links file name"
new() {
  opt_linksFilePath="$WORK_PATH/links/default.links"
  if [ $# -eq 1 ]; then
    opt_linksFilePath="$WORK_PATH/links/$1.links"
  fi
  _mkfile "$opt_linksFilePath"
}
