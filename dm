#!/bin/sh
set -eu


FILE_PATH="$(realpath "$0")"
WORK_PATH="$(dirname "$FILE_PATH")"

DOTFILES_MANAGER="$WORK_PATH/.dotfiles-manager/dm"

if ! [ -f "$DOTFILES_MANAGER" ]; then
  git submodule init
fi
git submodule update

CONFIG_PATH="$WORK_PATH/config.sh" "$DOTFILES_MANAGER" "$@"
