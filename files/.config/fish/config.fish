set fish_dir (dirname (status --current-filename))

source $fish_dir/paths.fish
source $fish_dir/variables.fish
source $fish_dir/colors.fish
source $fish_dir/aliases.fish

if [ -f $fish_dir/local_config.fish ]
  source $fish_dir/local_config.fish
end

if type -q tmux
  source $fish_dir/tmux_setup.fish
end

