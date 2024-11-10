
[[ $- != *i* ]] && return


HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

case "$TERM" in
    xterm-color|*-256color) color_prompt=yes ;;
esac

#force_color_prompt=yes
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
    else
    color_prompt=
    fi
fi

unset color_prompt force_color_prompt

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi



PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/go/bin:$PATH"

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if type tmux > /dev/null 2>&1; then
  export TMUX_SHELL="$(which bash)"
fi

if type zoxide > /dev/null 2>&1; then
  eval "$(zoxide init bash)"
fi

if [ -f ~/.fzf.bash ]; then
  source ~/.fzf.bash
fi

if [ -e ~/.local/share/blesh/ble.sh ]; then
  source ~/.local/share/blesh/ble.sh
fi

if type starship > /dev/null 2>&1; then
  eval "$(starship init bash)"
fi

if type broot > /dev/null 2>&1; then
  if [ -e ~/.config/broot/launcher/bash/br ]; then
    source ~/.config/broot/launcher/bash/br
  fi
fi


alias ls='ls --color=auto'

alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"

if type trash > /dev/null 2>&1; then
  alias rm="trash"
fi

alias ..="cd .."

alias l="ls -F"
alias la="ls -FA"
alias ll="ls -Fl"
alias lla="ls -Fla"

if type git > /dev/null 2>&1; then
  alias g="git"
  alias ga="git add"
  alias gp="git push"
  alias gpl="git pull"
  alias gs="git status"
  alias gss="git status -s"
  alias gd="git diff"
  alias gco="git checkout"
  alias gc="git commit"
  alias gcm="git commit -m"
  alias gb="git branch"
fi

if type nvim > /dev/null 2>&1; then
  nvimFunc() {
    if [ "${NVIM:-}" = "" ]; then
      nvim "$@"
    else
      nvim --server "$NVIM" --remote-send "<CMD>call v:lua.TerminalOpenFile(\"${1:-}\", \"$PWD\")<CR>"
    fi
  }
  alias nvim="nvimFunc"
fi

alias h='printf "\033[?25l\033[0;0H\033[2J"&& read && printf "\033[?25h"'
alias c='printf "\033[0;0H\033[2J"'
alias q="exit"
