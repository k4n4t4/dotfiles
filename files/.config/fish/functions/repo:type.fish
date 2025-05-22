function repo:type
  if hg:is_repo
    echo 'hg'
  else if git:is_repo
    echo 'git'
  else
    return 1
  end
  return 0
end
