
function fish_exit --on-event fish_exit
  printf "\033[100m\033[97m exit \033[m\n"
end

function fish_preexec --on-event fish_preexec
  printf "\033[38;5;239m"
  yes "─" | head -n $COLUMNS | tr -d "\n"
  printf "\033[m\r"
  echo
end

function fish_postexec --on-event fish_postexec
  # if test "$argv[1]" = "clear"
  #   return
  # end
  # printf "\033[m"
  # yes = | head -n $COLUMNS | tr -d "\n"
  # echo
  :
end
