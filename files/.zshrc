export LANG=ja_JP.UTF-8

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


PATH="$HOME/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="/snap/bin:$PATH"
PATH="/usr/sandbox/:$PATH"
PATH="/usr/local/bin:$PATH"
PATH="/usr/share/games:$PATH"
PATH="/usr/local/sbin:$PATH"
PATH="/usr/sbin:$PATH"
PATH="/sbin:$PATH"
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
export LS_COLORS="$(get_ls_colors)"
export PROMPT=" %F{green}%~ %F{yellow}%? %F{cyan}%#%f "


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
alias la="ls -Fa"
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

alias h='printf "\033[?25l\033[0;0H\033[2J"&& read && printf "\033[?25h"'
alias c='printf "\033[0;0H\033[2J"'
alias q="exit"


### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting

