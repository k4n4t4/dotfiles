#!/bin/sh
set -eu
cd "$(dirname "$0")"
. "./sh_lib/var.sh"
. "./sh_lib/print.sh"
. "./sh_lib/sub_func.sh"
. "./sh_lib/main_func.sh"
read_options "$@"

if $OPTION_HELP ; then
  usage
  exit_log
fi

dotfiles_banner

check_os "$OS"
get_distro

print_variables \
  OS \
  DISTRO \
  OPTION_HELP \
  OPTION_FORCE \
  OPTION_UNINSTALL \
  DOTFILES_DIR \
  HOME_DIR
:

read -p "[$ESC[92my$ESC[m/$ESC[91mN$ESC[m]: " Ans

case "$Ans" in
  [yY]* )
    . ./link_list.sh
    exit_log "Done!"
    ;;
  * )
    exit_log "Cancel!"
    ;;
esac
