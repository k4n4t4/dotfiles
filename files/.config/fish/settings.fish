set fish_handle_reflow 0

set fish_color_normal         brwhite
set fish_color_autosuggestion brblack
set fish_color_command        green
set fish_color_error          red
set fish_color_comment        white
set fish_color_cancel         red
set fish_color_escape         cyan
set fish_color_operator       purple
set fish_color_param          blue
set fish_color_quote          yellow
set fish_color_redirection    cyan
set fish_color_end            brwhite
set fish_color_match          brcyan --underline
set fish_color_search_match   --background=brblack
set fish_color_selection      --background=brblack
set fish_color_user           brblue
set fish_color_host           brgreen
set fish_color_host_remote    bryellow
set fish_color_cwd            blue
set fish_color_cwd_root       red

set fish_pager_color_selected_background -r
set fish_pager_color_completion          brblack
set fish_pager_color_prefix              white
set fish_pager_color_description         cyan
set fish_pager_color_progress            brwhite

fish_add_path \
  ~/bin \
  ~/.local/bin \
  ~/go/bin \
  ~/.cargo/bin \
  /snap/bin \
  /usr/local/bin \
  /usr/local/sbin \
  /usr/sbin \
  /sbin

export FISH_BIN=(which fish)

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
  export TMUX_SHELL=$FISH_BIN
end

if test -f /home/linuxbrew/.linuxbrew/bin/brew
  eval (/home/linuxbrew/.linuxbrew/bin/brew shellenv)
end

if type -q fzf
  fzf --fish | source
end

if type -q thefuck
  eval (thefuck --alias | tr '\n' ';')
end

if type -q zoxide
  zoxide init fish --cmd z | source
end

if type -q broot
  broot --print-shell-function fish | source
end


# starship setup
if type -q starship
  starship init fish | source

  function starship_transient_prompt_func
    starship prompt --profile transient_prompt
  end
  function starship_transient_rprompt_func
    starship prompt --profile transient_rprompt
  end

  enable_transience
end
