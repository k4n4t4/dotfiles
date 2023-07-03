function fish_user_key_bindings
  bind \er 'commandline -i  \\\\\\n'
  bind \eg 'commandline -r "cd "'
  bind \e/ 'cdgitroot && commandline -f repaint'
  bind \ev 'fish_clipboard_paste'
  bind \ec 'beginning-of-line' 'kill-word'
  bind \ek 'commandline ""'
  bind \t 'commandline -f complete'
  bind \n 'fish_force_preexec && commandline -f execute'
  bind \r 'fish_force_preexec && commandline -f execute'
  bind \eR 'commandline -f repaint'
end
