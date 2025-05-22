function git:branch_name
  set -l branch (git symbolic-ref --quiet HEAD 2> /dev/null)
  if set -q branch[1]
    echo (string replace -r '^refs/heads/' '' $branch)
  else
    echo (git rev-parse --short HEAD 2> /dev/null)
  end
end
