% git

# change branch
git checkout <branch>

# change commit
git checkout <commit>

# new branch
git checkout -b <new_branch_name>

# list all branches
git branch -a


$ branch: git for-each-ref --format='%(objectname:short) %(refname:short)' --- --map 'awk "{print \$2}"'
$ commit: git log --oneline --- --map 'awk "{print \$1}"'

