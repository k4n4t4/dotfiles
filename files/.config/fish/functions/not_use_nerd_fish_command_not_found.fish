function fish_command_not_found
  printf "\033[41m\033[37m "
  printf "Did not find command: \033[97m$argv[1]"
  printf " \033[m\n"
end
