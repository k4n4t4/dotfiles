#!/bin/sh
set -eu

#  #####   ####  ##### ###### # #      ######  ####   #
#  #    # #    #   #   #      # #      #      #       #
#  #    # #    #   #   #####  # #      #####   ####   #
#  #    # #    #   #   #      # #      #           #  #
#  #    # #    #   #   #      # #      #      #    #  #
#  #####   ####    #   #      # ###### ######  ####   #

. ./scripts/var.sh
. ./scripts/print_func.sh
. ./scripts/sub_func.sh
. ./scripts/main_func.sh

TITLE "${0}"

READ_OPTION "${@}"

if "${OPTION_HELP}"; then
  PRINT_HELP
  EXIT
fi

DOTFILES_BANNER

CHECK_OS "${os}"

GET_DISTRO

INFO "Variables"
PRINT_VARIABLES \
  "OPTION_HELP" \
  "OPTION_YES" \
  "OPTION_FORCE" \
  "OPTION_NOT_USE_NERD_FONT" \
  "OPTION_UNINSTALL" \
  "os" \
  "distro" \
  "dotfiles_root" \
  "targetdir_root"
: -PRINT_VARIABLES-

if "${OPTION_YES}"; then
  Ans="y"
else
  READ_MSG "yN"
  read "Ans"
fi

case "${Ans}" in
  [Yy]* )
    if "${OPTION_UNINSTALL}"; then
      LOG "Uninstall start"
    else
      LOG "Install start"
    fi
    ;;
  * )
    ERROR "Cancel"
    EXIT
    ;;
esac


INFO "Command Exist"
CMD_EXIST \
  "sh" \
  "git" \
  "bash" \
  "fish" \
  "vim" \
  "nvim" \
  "tmux" \
  "neofetch" \
  "code" \
  "codium"
: -CMD_EXIST-


if "${OPTION_UNINSTALL}"; then
  INFO "Delete Link"
  . ./scripts/lists/link_list.sh
  
  LOG "Uninstall is completed."
else
  INFO "Create Dir"
  . ./scripts/lists/dir_list.sh
  
  INFO "Create Link"
  . ./scripts/lists/link_list.sh
  
  LOG "Installation is completed."
fi

LOG "link : (${link_suc_count}/${link_count})"
LOG "dir  : (${dir_suc_count}/${dir_count})"

EXIT
