function fish_user_key_bindings
  # load preset keybind
  fish_hybrid_key_bindings

  # Default mode keybinds
  bind --mode default p 'keybind:paste'

  # Visual mode keybinds
  bind --mode visual p 'keybind:paste'

  # Insert mode keybinds
  bind --mode insert \cl 'keybind:clear-screen'
  bind --mode insert \t 'keybind:complete'
  bind --mode insert \eR 'keybind:repaint'
  bind --mode insert \cb 'keybind:file-browser'
  bind --mode insert \cd 'keybind:dir-browser'
  bind --mode insert \ch 'keybind:history-search'
  bind --mode insert \cg 'keybind:git-status'
  bind --mode insert \cp 'keybind:paste-path'
  bind --mode insert \eC 'keybind:cd-recent'
end
