
function cdr
  if type -q fzf
    set find_dir (z -l | awk '{print $2}' | fzf --prompt "z > " --query "$argv")
  else if type -q peco
    set find_dir (z -l | awk '{print $2}' | peco --prompt "z >" --query "$argv")
  else
    echo "Please install peco or fzf."
    return 1
  end
end

