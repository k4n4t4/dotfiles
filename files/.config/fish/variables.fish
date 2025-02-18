set fish_handle_reflow 0

export fish_bin=(which fish)

export PAGER="less"

export LESS='-i -M -R -S -W -z-4 -x4'
export LESS_TERMCAP_mb=\033"[1;31m"
export LESS_TERMCAP_md=\033"[1;32m"
export LESS_TERMCAP_me=\033"[m"
export LESS_TERMCAP_so=\033"[1;40;35m"
export LESS_TERMCAP_se=\033"[m"
export LESS_TERMCAP_us=\033"[36m"
export LESS_TERMCAP_ue=\033"[m"

export EDITOR="nvim"

export LANG=C.UTF-8

if type -q tmux
  export TMUX_SHELL=$fish_bin
end

if type -q fzf
  fzf --fish | source
end
