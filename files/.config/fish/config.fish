export fish_dir=(dirname (status --current-filename))

source $fish_dir/settings.fish
source $fish_dir/aliases.fish


# source local config
if test -f ~/.rc.fish
  source ~/.rc.fish
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
