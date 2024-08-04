export fish_dir=(dirname (status --current-filename))

source $fish_dir/paths.fish
source $fish_dir/variables.fish
source $fish_dir/colors.fish
source $fish_dir/aliases.fish

if test -f ~/.fishrc
  source ~/.fishrc
end

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
