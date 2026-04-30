if cmd_exists tmux; then
  dotconf "tmux" -r -i "tmux.conf"
  dothome ".config/tmux/tmux.conf" ".tmux.conf"
fi
