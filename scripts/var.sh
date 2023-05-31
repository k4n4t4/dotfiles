#!/bin/sh
set -eu

# exit status
STATUS=0

# option
OPTION_HELP=false
OPTION_YES=false
OPTION_FORCE=false
OPTION_NOT_USE_NERD_FONT=false
OPTION_UNINSTALL=false

# size
eval "$(resize)"

# count
dir_count=0
dir_suc_count=0
link_count=0
link_suc_count=0

# main
os="$(uname)"
distro="?"
dotfiles_root="$(pwd)"
targetdir_root="${HOME}"
