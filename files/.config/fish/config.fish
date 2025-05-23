if status is-interactive
  export fish_dir=(dirname (status --current-filename))

  source $fish_dir/settings.fish
  source $fish_dir/aliases.fish

  if test -f ~/.rc.fish
    source ~/.rc.fish
  end
end
