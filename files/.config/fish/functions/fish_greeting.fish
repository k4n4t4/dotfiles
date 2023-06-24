function fish_greeting
  if type -q tmux
  and status is-interactive
  and not set -q TMUX
    printf "%s" (whoami) "@" (hostname)
    printf "\n"
    for i in (seq $COLUMNS)
      printf "="
    end
    printf "\n"
    tmux list-session
    for i in (seq $COLUMNS)
      printf "="
    end
    printf "\n"
  else
    if type -q figlet && test $COLUMNS -gt 50
      if type -q lolcat
        figlet (date +%m/%d/%y) | lolcat
      else
        figlet (date +%m/%d/%y)
      end
    else
      echo
      if type -q lolcat
        date +%m/%d/%y | lolcat
      else
        date +%m/%d/%y
      end
      echo
    end
  end
end
