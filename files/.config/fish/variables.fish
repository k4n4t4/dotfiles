
set -g fish_handle_reflow 0

if type -q exa
  export EXA_COLORS=(get_ls_colors exa)
else
  export LS_COLORS=(get_ls_colors)
end

export LESS='-i -M -R -S -W -z-4 -x4'
export PAGER="less"

export LESS_TERMCAP_mb=(printf "\e[1;31m")
export LESS_TERMCAP_md=(printf "\e[1;32m")
export LESS_TERMCAP_me=(printf "\e[m")

export LESS_TERMCAP_so=(printf "\e[1;40;35m")
export LESS_TERMCAP_se=(printf "\e[m")

export LESS_TERMCAP_us=(printf "\e[36m")
export LESS_TERMCAP_ue=(printf "\e[m")

export EDITOR="nvim"
export LANG=C
export WHICH_FISH=(which fish)

set _transient_prompt true

