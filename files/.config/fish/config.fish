export fish_dir=(dirname (status --current-filename))

source $fish_dir/paths.fish
source $fish_dir/variables.fish
source $fish_dir/colors.fish
source $fish_dir/aliases.fish


# source local config
if test -f ~/.rc.fish
  source ~/.rc.fish
end


if type -q starship

  # starship init
  starship init fish | source


  # starship transient prompt
  function starship_transient_prompt_func
    starship prompt --profile transient_prompt
  end

  # starship transient right prompt
  function starship_transient_rprompt_func
    starship prompt --profile transient_rprompt
  end

  enable_transience
end
