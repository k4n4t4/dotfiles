set fish_handle_reflow 0

export fish_bin=(which fish)

export PAGER="less"

export LESS='-i -M -R -S -W -z-4 -x4'
export LESS_TERMCAP_mb=(printf "\e[1;31m")
export LESS_TERMCAP_md=(printf "\e[1;32m")
export LESS_TERMCAP_me=(printf "\e[m")
export LESS_TERMCAP_so=(printf "\e[1;40;35m")
export LESS_TERMCAP_se=(printf "\e[m")
export LESS_TERMCAP_us=(printf "\e[36m")
export LESS_TERMCAP_ue=(printf "\e[m")

export EDITOR="nvim"

export LANG=C.UTF-8

if type -q tmux
  export TMUX_SHELL=$fish_bin
end
