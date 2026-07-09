% git

# change branch
git checkout <branch>

# new branch
git checkout -b <new_branch_name>

# list all branches
git branch -a


$ branch: git for-each-ref --format='%(objectname:short) %(refname:short)' --- --map 'awk "{print \$2}"'
