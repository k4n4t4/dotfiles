function fish_user_key_bindings
  bind \er 'commandline -i  \\\\\\n'
  bind \eg 'commandline -r "cd "'
  bind \e/ 'cdgitroot && commandline -f repaint'
  bind \ev 'fish_clipboard_paste'
  bind \ec 'beginning-of-line' 'kill-word'
  bind \ek 'commandline ""'
  bind \t 'commandline -f complete'
  bind \eR 'commandline -f repaint'
  bind \cr '__fzf_reverse_isearch'
  bind \cf '__fzf_cd'
  bind \c] 'cdg (commandline)'
  bind \cv 'commandline -i (set | awk \'{print $1}\' | fzf)'
  bind \cb 'commandline -i (fd -H | fzf --preview \'bat --style=numbers --color=always --line-range :300 {}\')'
end

fzf --fish | source
