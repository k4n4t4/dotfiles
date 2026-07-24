% chmod

# with number
chmod <mode> <file>

$ mode: echo "755 644 700 600" | tr ' ' '\n'
$ file: ls -1a

# with symbols
chmod <who><op><perm> <file>

$ who: printf "user\ngroups\nother\nall\n" --- --map "sed 's/user/u/; s/groups/g/; s/other/o/; s/all/a/'"
$ op: echo "+ - =" | tr ' ' '\n'
$ perm: printf "read\nwrite\nexecute\n" --- --map "sed 's/read/r/; s/write/w/; s/execute/x/'"
$ file: ls -1a

# with number recursive
chmod -R <mode> <file>

$ mode: echo "755 644 700 600" | tr ' ' '\n'
$ file: ls -1a

# with symbols recursive
chmod -R <who><op><perm> <file>

$ who: printf "user\ngroups\nother\nall\n" --- --map "sed 's/user/u/; s/groups/g/; s/other/o/; s/all/a/'"
$ op: echo "+ - =" | tr ' ' '\n'
$ perm: printf "read\nwrite\nexecute\n" --- --map "sed 's/read/r/; s/write/w/; s/execute/x/'"
$ file: ls -1a
