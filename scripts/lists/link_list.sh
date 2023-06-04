#!/bin/sh
set -eu

if "${sh_exist}"; then
  LINK \
    ".config/sh/.profile" \
    ".profile"
fi

if "${bash_exist}"; then
  LINK \
    ".config/bash/.bashrc" \
    ".bashrc" \
    \
    ".config/bash/.bash_aliases" \
    ".bash_aliases"
fi

if "${fish_exist}"; then
  LINK \
    ".config/fish/config.fish" \
    ".config/fish/config.fish" \
    \
    ".config/fish/fish_plugins" \
    ".config/fish/fish_plugins" \
    \
    ".config/fish/conf.d/alias.fish" \
    ".config/fish/conf.d/alias.fish" \
    \
    ".config/fish/conf.d/color.fish" \
    ".config/fish/conf.d/color.fish" \
    \
    ".config/fish/conf.d/path.fish" \
    ".config/fish/conf.d/path.fish" \
    \
    ".config/fish/conf.d/git_func.fish" \
    ".config/fish/conf.d/git_func.fish" \
    \
    ".config/fish/conf.d/bind.fish" \
    ".config/fish/conf.d/bind.fish" \
    \
    ".config/fish/functions/mkcd.fish" \
    ".config/fish/functions/mkcd.fish" \
    \
    ".config/fish/functions/cdls.fish" \
    ".config/fish/functions/cdls.fish" \
    \
    ".config/fish/functions/clearls.fish" \
    ".config/fish/functions/clearls.fish" \
    \
    ".config/fish/functions/sudo.fish" \
    ".config/fish/functions/sudo.fish" \
    \
    ".config/fish/functions/title.fish" \
    ".config/fish/functions/title.fish" \
    \
    ".config/fish/functions/fish_greeting.fish" \
    ".config/fish/functions/fish_greeting.fish"
    
  if "${OPTION_NOT_USE_NERD_FONT}"; then
    LINK \
      ".config/fish/conf.d/not_use_nerd_event_functions.fish" \
      ".config/fish/conf.d/event_functions.fish" \
      \
      ".config/fish/functions/not_use_nerd_fish_command_not_found.fish" \
      ".config/fish/functions/fish_command_not_found.fish" \
      \
      ".config/fish/functions/not_use_nerd_fish_prompt.fish" \
      ".config/fish/functions/fish_prompt.fish"
  else
    LINK \
      ".config/fish/conf.d/event_functions.fish" \
      ".config/fish/conf.d/event_functions.fish" \
      \
      ".config/fish/functions/fish_command_not_found.fish" \
      ".config/fish/functions/fish_command_not_found.fish" \
      \
      ".config/fish/functions/fish_prompt.fish" \
      ".config/fish/functions/fish_prompt.fish"
  fi
fi

if "${vim_exist}"; then
  LINK \
    ".config/vim/.vimrc" \
    ".vimrc"
fi

if "${nvim_exist}"; then
  LINK \
    ".config/nvim/init.lua" \
    ".config/nvim/init.lua" \
    \
    ".config/nvim/coc-settings.json" \
    ".config/nvim/coc-settings.json" \
    \
    ".config/nvim/lua" \
    ".config/nvim/lua"
fi

if "${tmux_exist}"; then
  LINK \
    ".config/tmux/.tmux.conf" \
    ".tmux.conf" \
    \
    ".config/tmux/style.conf" \
    ".config/tmux/style.conf" \
    \
    ".config/tmux/bind.conf" \
    ".config/tmux/bind.conf" \
    \
    ".config/tmux/format.conf" \
    ".config/tmux/format.conf"

  if "${OPTION_NOT_USE_NERD_FONT}"; then
    LINK \
      ".config/tmux/not_use_nerd_formats" \
      ".config/tmux/formats"
  else
    LINK \
      ".config/tmux/formats" \
      ".config/tmux/formats"
  fi

fi

if "${neofetch_exist}"; then
  LINK \
    ".config/neofetch/config.conf" \
    ".config/neofetch/config.conf"
fi

if "${codium_exist}"; then
  LINK \
    ".config/VSCodium/User/keybindings.json" \
    ".config/VSCodium/User/keybindings.json" \
    \
    ".config/VSCodium/User/settings.json" \
    ".config/VSCodium/User/settings.json" \
    \
    ".config/VSCodium/User/snippets" \
    ".config/VSCodium/User/snippets"
fi
