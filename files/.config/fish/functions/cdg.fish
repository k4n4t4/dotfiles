
function cdg
  if type -q peco
    set git_dir (ghq list --full-path | peco --prompt "ghq >" --query "$argv")
  else if type -q fzf
    set git_dir (ghq list --full-path | fzf --prompt "ghq > " --query "$argv")
  end
  cd $git_dir
end

