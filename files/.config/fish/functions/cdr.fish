function cdr
  if type -q fzf
    set z_dir (zoxide query -l | fzf --prompt "z > " --query "$argv")
  else if type -q peco
    set z_dir (zoxide query -l | peco --prompt "z >" --query "$argv")
  else
    echo "Please install peco or fzf."
    return 1
  end
  cd $z_dir
end
