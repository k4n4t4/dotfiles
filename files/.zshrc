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

ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern cursor root line)
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[default]='none'
ZSH_HIGHLIGHT_STYLES[unknown-token]='fg=red,bold'
ZSH_HIGHLIGHT_STYLES[reserved-word]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[suffix-alias]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[global-alias]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[precommand]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[commandseparator]='none'
ZSH_HIGHLIGHT_STYLES[autodirectory]='fg=green,underline'
ZSH_HIGHLIGHT_STYLES[path]='underline'
ZSH_HIGHLIGHT_STYLES[path_pathseparator]=''
ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=''
ZSH_HIGHLIGHT_STYLES[globbing]='fg=blue'
ZSH_HIGHLIGHT_STYLES[history-expansion]='fg=blue'
ZSH_HIGHLIGHT_STYLES[command-substitution]='none'
ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[process-substitution]='none'
ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]='fg=blue'
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]='fg=blue'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]='none'
ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]='fg=magenta'
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[rc-quote]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]='fg=cyan'
ZSH_HIGHLIGHT_STYLES[assign]='none'
ZSH_HIGHLIGHT_STYLES[redirection]='fg=yellow'
ZSH_HIGHLIGHT_STYLES[comment]='fg=black,bold'
ZSH_HIGHLIGHT_STYLES[named-fd]='none'
ZSH_HIGHLIGHT_STYLES[numeric-fd]='none'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=green'

alias reboot   "systemctl reboot"
alias poweroff "systemctl poweroff"

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

alias ".."="cd .."

if type eza > /dev/null 2>&1; then
  alias eza="eza --icons --git -H --sort=type --time-style=long-iso"
  alias ls="eza"
  alias ll="eza -F -l"
  alias la="eza -F -a"
  alias lla="eza -F -la"
  alias l="eza -F"
  alias lt="eza -F -T"
  alias lta="eza -F -Ta"
  alias llt="eza -F -Tl"
  alias llta="eza -F -Tla"
  export EXA_COLORS=(get_ls_colors exa)
elif type exa > /dev/null 2>&1; then
  alias exa="exa --icons --git -H -s type --time-style=long-iso"
  alias ls="exa"
  alias ll="exa -Fl"
  alias la="exa -Fa"
  alias lla="exa -Fla"
  alias l="exa -F"
  alias lt="exa -FT"
  alias lta="exa -FTa"
  alias llt="exa -FTl"
  alias llta="exa -FTla"
  export EXA_COLORS=(get_ls_colors exa)
elif type lsd > /dev/null 2>&1; then
  alias ls="lsd"
  alias ll="lsd -Fl"
  alias la="lsd -Fa"
  alias lA="lsd -FA"
  alias lla="lsd -Fla"
  alias llA="lsd -FlA"
  alias l="lsd -F"
  alias lt="lsd -F --tree"
  alias lta="lsd -Fa --tree"
  alias llt="lsd -Fl --tree"
  alias llta="lsd -Fla --tree"
else
  alias l="ls -F"
  alias ll="ls -Fl"
  alias la="ls -Fa"
  alias lla="ls -Fla"
  export LS_COLORS=(get_ls_colors)
fi

alias c='printf "\033[0;0H\033[2J"'
alias q="exit"

if type tmux > /dev/null 2>&1; then
  export TMUX_SHELL="$(which zsh)"
  alias tmux "tmux -u"
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

if type abbr > /dev/null 2>&1; then

  abbr -q -S c="clear"
  abbr -q -S "^"="command"

  abbr -q -S "cd-"="cd -"
  abbr -q -S "cd~"="cd ~"
  abbr -q -S "cd."="cd ."
  abbr -q -S "cd.."="cd .."

  abbr -q -S h="history"
  abbr -q -S q="exit"

  abbr -q -S rbt="reboot"
  abbr -q -S pof="poweroff"

  if type tmux > /dev/null 2>&1; then
    abbr -q -S tm="tmux"
    abbr -q -S tma="tmux attach-session"
    abbr -q -S tmat="tmux attach-session -t"
    abbr -q -S tmnew="tmux new-session -d"
    abbr -q -S tmnews="tmux new-session -s"
    abbr -q -S tmtree="tmux choose-tree"
    abbr -q -S tmcd="tmux switch-client"
    abbr -q -S tmcdt="tmux switch-client -t"
    abbr -q -S tmcdn="tmux switch-client -n"
    abbr -q -S tmcdp="tmux switch-client -p"
    abbr -q -S tmcdl="tmux switch-client -l"
    abbr -q -S tmmv="tmux rename"
    abbr -q -S tmmvt="tmux rename -t"
    abbr -q -S tmls="tmux list-sessions"
    abbr -q -S tmlsc="tmux list-clients"
    abbr -q -S tmd="tmux detach-client"
    abbr -q -S tmcl="tmux clear-history"
    abbr -q -S tmclear="clear ; tmux clear-history"
    abbr -q -S tmrm="tmux kill-session"
    abbr -q -S tmrmt="tmux kill-session -t"
    abbr -q -S tmkill="tmux kill-server"
  fi

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

  if type nvim > /dev/null 2>&1; then
    abbr -q -S v="nvim"
  elif type vim > /dev/null 2>&1; then
    abbr -q -S v="vim"
  fi

  if type todo > /dev/null 2>&1; then
    abbr -q -S t="todo"
    abbr -q -S ta="todo add"
    abbr -q -S tad="todo add"
    abbr -q -S td="todo del"
    abbr -q -S trm="todo del"
    abbr -q -S tmv="todo move"
    abbr -q -S tt="todo tag"
    abbr -q -S ttag="todo tag"
    abbr -q -S ts="todo status"
    abbr -q -S tst="todo status"
    abbr -q -S tl="todo list"
    abbr -q -S tls="todo list"
    abbr -q -S tcl="todo clear"
  fi

fi
