function cdr
  set -l find_pipe

  if type -q fzf
    set find_pipe fzf --prompt " zoxide > " --query "$argv"
  else if type -q peco
    set find_pipe peco --prompt " zoxide > " --query "$argv"
  else
    echo "Please install peco or fzf."
    return 1
  end

  set -l z_dir (zoxide query -l | $find_pipe)

  if test -n "$z_dir"
    cd $z_dir
  end
end
