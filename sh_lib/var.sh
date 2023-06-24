#!/bin/sh
set -eu

ESC="$(printf "\033")"

OS="$(uname)"
DISTRO="?"
DOTFILES_DIR="$(pwd)"
HOME_DIR="$HOME"
OPTION_HELP=false
OPTION_FORCE=false
OPTION_UNINSTALL=false

STATUS=0
