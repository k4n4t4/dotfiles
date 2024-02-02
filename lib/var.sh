OS="`uname`"
DISTRO="`get_distro`"
TARGET_DIR="$HOME"
DOTFILES_DIR="`pwd`"

if [ "${COLUMNS:-}" = "" ]; then
  SIZE="`get_size`"
  LINES="`echo $SIZE | cut -d ";" -f 1`"
  COLUMNS="`echo $SIZE | cut -d ";" -f 2`"
fi

ESC="`printf "\033"`"

mode=unknown
opt_force=false
