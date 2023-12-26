
functions --copy cd __cd

function cd
  set -f old_pwd (pwd)
  __cd $argv
  echo "$old_pwd -> "(pwd)
end
