function sudo -d "sudo wrapper that handles aliases"

  if functions -q -- $argv[1]
    set -l new_args (string join ' ' -- (string escape -- $argv))
    set argv fish -c "$new_args"
  end

  printf "\033[48;5;18m\033[38;5;33m\033[1m "
  printf "SUDO"
  printf " \033[38;5;18m\033[48;5;17m\033[38;5;33m\033[1m "
  printf "Password"
  printf " \033[m\033[38;5;17m\033[m "
  command sudo -p "" $argv
end
