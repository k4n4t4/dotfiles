function fish_user_key_bindings
  bind --mode default p 'fish_clipboard_paste'
  bind --mode insert \t 'commandline -f complete'
  bind --mode insert \eR 'commandline -f repaint'
  bind --mode insert \cb 'commandline -i (fd -H | fzf --preview \'bat --style=numbers --color=always --line-range :300 {}\')'

  # load preset keybind
  fish_hybrid_key_bindings
end
