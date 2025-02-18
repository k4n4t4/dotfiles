function cdf
  set -l find_cmd
  set -l find_pipe

  if type -q fd
    set find_cmd fd -H -t d
  else
    set find_cmd find -type d
  end

  if type -q fzf
    set find_pipe fzf --prompt " > " --query "$argv"
  else if type -q peco
    set find_pipe peco --prompt " > " --query "$argv"
  else
    echo "Please install peco or fzf."
    return 1
  end

  set -l find_dir ($find_cmd | $find_pipe)

  if test -n "$find_dir"
    cd $find_dir
  end
end
