% chmod cheat

# with number
chmod <mode> <file>

$ mode: echo "755 644 700 600" | tr ' ' '\n'
$ file: ls -1

# with symbols
chmod <who><op><perm> <file>

$ who: echo "u g o a" | tr ' ' '\n'
$ op: echo "+ - =" | tr ' ' '\n'
$ perm: echo "r w x" | tr ' ' '\n'
$ file: ls -1
