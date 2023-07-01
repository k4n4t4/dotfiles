
function cdf
  if type -q fd
    if type -q fzf
      set find_dir (fd -H -t d | fzf --prompt "ghq > " --query "$argv")
    else if type -q peco
      set find_dir (fd -H -t d | peco --prompt "ghq >" --query "$argv")
    else
      echo "Please install peco or fzf."
      return 1
    end
  else
    if type -q peco
      set find_dir (find -type d | peco --prompt "ghq >" --query "$argv")
    else if type -q fzf
      set find_dir (find -type d | fzf --prompt "ghq > " --query "$argv")
    else
      echo "Please install peco or fzf."
      return 1
    end
  end
  cd $find_dir
end

