export LANG=en_US.UTF-8
export CLICOLOR=1

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


# autoload

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


# path

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


# source

if [ -e /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
fi
if [ -e ~/.brew/bin/brew ]; then
    eval $(~/.brew/bin/brew shellenv)
fi

if type micromamba > /dev/null 2>&1 ; then
    export MAMBA_ROOT_PREFIX="$HOME/.micromamba"
    eval "$(micromamba shell hook --shell zsh)"
fi

if type sheldon > /dev/null 2>&1 ; then
    eval "$(sheldon source)"
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

if type starship > /dev/null 2>&1 ; then
    eval "$(starship init zsh)"
fi

# aliases

if type dm > /dev/null 2>&1; then
    eval "$(dm shellenv)"
fi

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
    export EXA_COLORS="$(get_ls_colors exa)"
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
    export EXA_COLORS="$(get_ls_colors exa)"
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

    export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx
    export LS_COLORS="$(get_ls_colors)"
fi

alias c='printf "\033[0;0H\033[2J"'
alias q="exit"

if type tmux > /dev/null 2>&1; then
    export TMUX_SHELL="$(which zsh)"
    alias tmux "tmux -u"
fi

if type zoxide > /dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if type yazi > /dev/null 2>&1; then
    function yazi() {
        local tmp=$(mktemp -t "yazi-cwd.XXXXXX")
        command yazi "$@" --cwd-file="$tmp"
        if cwd=$(cat -- "$tmp") && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
            cd -- "$cwd"
        fi
        rm -f -- "$tmp"
    }
fi
