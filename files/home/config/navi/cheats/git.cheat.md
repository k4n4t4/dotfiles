% git

# change branch
git checkout <branch>

# change commit
git checkout <commit>

# new branch
git checkout -b <new_branch_name>

# list all branches
git branch -a

# list stash
git stash list

# show stash
git stash show '<stash>'

# show log of a file
git log -p -- <file>

$ branch: git for-each-ref --format='%(objectname:short) %(refname:short)' --- --map 'awk "{print \$2}"'
$ commit: git log --oneline --- --map 'awk "{print \$1}"'
$ stash: git stash list --- --map "cut -d: -f1"
$ file: git ls-files --- --map "awk '{print \$1}'"
