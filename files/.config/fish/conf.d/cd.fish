functions --copy cd __cd

function cd
  set -l old_pwd $PWD

  __cd $argv
  if test "$old_pwd" != "$PWD"
    printf "\033[48;5;94m\033[38;5;214m\033[1m "
    printf "CD"
    printf " \033[38;5;94m\033[48;5;58m\033[38;5;214m\033[1m "
    printf "$old_pwd 󰁕 $PWD"
    printf " \033[m\033[38;5;58m\033[m\n"
  end
end
