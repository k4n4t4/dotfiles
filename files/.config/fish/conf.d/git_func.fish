function _git_branch_name
  set -l branch (git symbolic-ref --quiet HEAD 2>/dev/null)
  if set -q branch[1]
    echo (string replace -r '^refs/heads/' '' $branch)
  else
    echo (git rev-parse --short HEAD 2>/dev/null)
  end
end

function _is_git_dirty
  echo (git status -s --ignore-submodules=dirty 2>/dev/null)
end

function _is_git_repo
  type -q git
  or return 1
  git rev-parse --git-dir >/dev/null 2>&1
end

function _hg_branch_name
  echo (hg branch 2>/dev/null)
end

function _is_hg_dirty
  echo (hg status -mard 2>/dev/null)
end

function _is_hg_repo
  fish_print_hg_root >/dev/null
end

function _repo_branch_name
  _$argv[1]_branch_name
end

function _is_repo_dirty
  _is_$argv[1]_dirty
end

function _repo_type
  if _is_hg_repo
      echo 'hg'
      return 0
  else if _is_git_repo
      echo 'git'
      return 0
  end
  return 1
end
