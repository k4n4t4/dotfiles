function cdg
  set -l find_pipe

  if not type -q ghq
    echo "Please install ghq."
    return 1
  end

  if type -q fzf
    set find_pipe fzf --prompt " ghq > " --query "$argv"
  else if type -q peco
    set find_pipe peco --prompt " ghq > " --query "$argv"
  else
    echo "Please install peco or fzf."
    return 1
  end

  set -l git_dir (ghq list --full-path | $find_pipe)

  if test -n "$git_dir"
    cd $git_dir
  end
end
