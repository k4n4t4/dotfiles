#!/bin/sh
set -eu

info "===== bin (total: $(cat "lists/bin" | wc -l)) ====="
read_link_list "lists/bin"

if cmd_exist sh ; then
  info "===== sh (total: $(cat "lists/sh" | wc -l)) ====="
  read_link_list "lists/sh"
fi

if cmd_exist bash ; then
  info "===== bash (total: $(cat "lists/bash" | wc -l)) ====="
  read_link_list "lists/bash"
fi

if cmd_exist fish ; then
  info "===== fish (total: $(cat "lists/fish" | wc -l)) ====="
  read_link_list "lists/fish"
fi

if cmd_exist vim ; then
  info "===== vim (total: $(cat "lists/vim" | wc -l)) ====="
  read_link_list "lists/vim"
fi

if cmd_exist nvim ; then
  info "===== nvim (total: $(cat "lists/nvim" | wc -l)) ====="
  read_link_list "lists/nvim"
fi

if cmd_exist tmux ; then
  info "===== tmux (total: $(cat "lists/tmux" | wc -l)) ====="
  read_link_list "lists/tmux"
fi

if cmd_exist neofetch ; then
  info "===== neofetch (total: $(cat "lists/neofetch" | wc -l)) ====="
  read_link_list "lists/neofetch"
fi

if cmd_exist codium ; then
  info "===== codium (total: $(cat "lists/codium" | wc -l)) ====="
  read_link_list "lists/codium"
fi

if cmd_exist alacritty ; then
  info "===== alacritty (total: $(cat "lists/alacritty" | wc -l)) ====="
  read_link_list "lists/alacritty"
fi

if cmd_exist picom ; then
  info "===== picom (total: $(cat "lists/picom" | wc -l)) ====="
  read_link_list "lists/picom"
fi
