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
autoload -Uz colors
colors


if type trash > /dev/null 2>&1; then
  alias rm "trash"
else
  stopUseRm() {
    printf "\033[91mStop!\033[m\n\033[36mPlease install \"trash\" command.\033[m\n"
  }
  alias rm "stopUseRm"
fi

zsh_prompt() {
  printf " %%F{green}%%~ %%F{yellow}%%? %%F{cyan}%%#%%f "
}

PROMPT="$(zsh_prompt)"

