export fish_dir=(dirname (status --current-filename))

source $fish_dir/paths.fish
source $fish_dir/variables.fish
source $fish_dir/colors.fish
source $fish_dir/aliases.fish

if [ -f $fish_dir/local_config.fish ]
  source $fish_dir/local_config.fish
end

if type -q starship
  function starship_transient_prompt_func
    starship prompt --profile transient_prompt
  end
  function starship_transient_rprompt_func
    starship prompt --profile transient_rprompt
  end
  starship init fish | source
  enable_transience
end
