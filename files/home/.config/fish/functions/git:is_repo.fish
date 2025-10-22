function git:is_repo
  type -q git
  or return 1
  git rev-parse --git-dir > /dev/null 2>&1
end
