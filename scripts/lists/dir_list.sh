#!/bin/sh
set -eu

if "${fish_exist}"; then
  DIR \
    ".config/fish" \
    ".config/fish/conf.d" \
    ".config/fish/functions"
fi

if "${nvim_exist}"; then
  DIR ".config/nvim"
fi

if "${tmux_exist}"; then
  DIR ".config/tmux"
fi

if "${neofetch_exist}"; then
  DIR ".config/neofetch"
fi

if "${code_exist}" || "${codium_exist}"; then
  DIR "Documents/VSCode/workspaces"
fi

if "${codium_exist}"; then
  DIR ".config/VSCodium/User"
fi
