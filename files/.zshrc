export LANG=en_US.UTF-8

stty -ixon

setopt no_beep
setopt ignore_eof
setopt interactive_comments
setopt auto_pushd
setopt pushd_ignore_dups
setopt auto_cd
setopt print_eight_bit
setopt histignorealldups
setopt share_history
setopt extended_glob
setopt extended_history
setopt auto_menu
setopt menu_complete

HISTFILE=~/.zsh_history
HISTSIZE=5000
SAVEHIST=5000

bindkey -e

autoload -Uz compinit
compinit
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin
zstyle ':completion:*' menu yes select

autoload -Uz colors
colors

autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^[v" edit-command-line

zle -N dir_forward
zle -N dir_back

PATH="$HOME/bin:$PATH"
PATH="$HOME/go/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="/snap/bin:$PATH"
PATH="/usr/sandbox/:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="/usr/share/games:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/sbin:$PATH"
PATH="/sbin:$PATH"

if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
  eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi

if type sheldon > /dev/null 2>&1 ; then
  eval "$(sheldon source)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type starship > /dev/null 2>&1 ; then
  eval "$(starship init zsh)"
fi

export LANG=C
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LS_COLORS="$(get_ls_colors)"

alias ls='ls --color=auto'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias rm="rm -iv"
alias mv="mv -iv"
alias cp="cp -iv"

if type trash > /dev/null 2>&1; then
  alias rm="trash"
else
  stopUseRm() {
    printf "\033[91mStop!\033[m\n\033[36mPlease install \"trash\" command.\033[m\n"
  }
  alias rm="stopUseRm"
fi

alias ..="cd .."

alias l="ls -F"
alias la="ls -FA"
alias ll="ls -Fl"
alias lla="ls -Fla"

if type sl > /dev/null 2>&1; then
  alias al=sl -a
  alias lal=sl -al
  alias all=sl -al
fi

if type tmux > /dev/null 2>&1; then
  export TMUX_SHELL="$(which zsh)"
fi

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

if type zoxide > /dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

if type broot > /dev/null 2>&1; then
  eval "$(broot --print-shell-function zsh)"
fi

hide() {
  printf "\033[?25l"
  XT_EXTSCRN true
  read
  XT_EXTSCRN false
  printf "\033[?25h"
}

alias c='printf "\033[0;0H\033[2J"'
alias q="exit"


if type abbr > /dev/null 2>&1; then

  abbr -q -S c="clear"
  abbr -q -S "^"="command"

  abbr -q -S "cd-"="cd -"
  abbr -q -S "cd~"="cd ~"
  abbr -q -S "cd."="cd ."
  abbr -q -S "cd.."="cd .."

  if type git > /dev/null 2>&1; then
    abbr -q -S g="git"
    abbr -q -S ga="git add"
    abbr -q -S gd="git diff"
    abbr -q -S gdc="git diff --cached"
    abbr -q -S gs="git status"
    abbr -q -S gst="git status"
    abbr -q -S gss="git status -s"
    abbr -q -S gp="git push"
    abbr -q -S gpl="git pull"
    abbr -q -S gb="git branch"
    abbr -q -S gbd="git branch -d"
    abbr -q -S gbfd="git branch -D"
    abbr -q -S gm="git merge"
    abbr -q -S gco="git checkout"
    abbr -q -S gcob="git checkout -b"
    abbr -q -S gf="git fetch"
    abbr -q -S gc="git commit"
    abbr -q -S gcm="git commit -m"
    abbr -q -S gr="git remote"
    abbr -q -S gbl="git blame"
  fi

fi
