function sudo
  if functions -q -- $argv[1]
    set -l new_args (string join ' ' -- (string escape -- $argv))
    set argv fish -c "$new_args"
  end

  function sudo_prompt
    builtin printf "\033[48;5;18m\033[38;5;33m\033[1m "
    builtin printf "SUDO"
    builtin printf " \033[38;5;18m\033[48;5;17m\033[38;5;33m\033[1m "
    builtin printf "Password"
    builtin printf " \033[m\033[38;5;17m\033[m "
  end

  command sudo -p (sudo_prompt) $argv
end
