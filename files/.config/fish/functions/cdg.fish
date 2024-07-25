function cdg
  if not type -q ghq
    echo "Please install ghq."
    return 1
  end
  if type -q fzf
    set git_dir (ghq list --full-path | fzf --prompt "ghq > " --query "$argv")
  else if type -q peco
    set git_dir (ghq list --full-path | peco --prompt "ghq >" --query "$argv")
  else
    echo "Please install peco or fzf."
    return 1
  end
  cd $git_dir
end
