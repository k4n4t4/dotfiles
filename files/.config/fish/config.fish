
set fish_dir (dirname (status --current-filename))

# export
export EDITOR="nvim"
export LANG=C

source $fish_dir/aliases.fish
source $fish_dir/tmux_start.fish
