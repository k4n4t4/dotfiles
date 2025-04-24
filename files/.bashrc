[[ $- != *i* ]] && return


HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
set -o vi


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
  _nvim() {
    if [ "${NVIM:-}" = "" ]; then
      command nvim "$@"
    else
      while [ $# -gt 0 ]; do
        command nvim --server "$NVIM" --remote-tab "$(realpath "$1")"
        shift
      done
    fi
  }
  alias nvim="_nvim"
fi

alias h='printf "\033[?25l\033[0;0H\033[2J"&& read && printf "\033[?25h"'
alias c='printf "\033[0;0H\033[2J"'
alias q="exit"

alias v="vim"

export PS1="\[\033[35m\]\$?\[\033[90m\]-\[\033[36m\]\h@\u\[\033[90m\]:\[\033[33m\]\w\[\033[m\]\\$ "

# I hate emacs.
# I love vim.
alias emacs="vim"
