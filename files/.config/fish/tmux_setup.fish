if status is-interactive; and not set -q TMUX
  function fish_greeting; end
  set LIST (tmux list-session)
  if test -z "$LIST"
    exec tmux -u new-session
  else
    printf "%s" (whoami) "@" (hostname)
    echo
    yes = | head -n $COLUMNS | tr -d "\n"
    echo
    tmux list-session
    yes = | head -n $COLUMNS | tr -d "\n"
    echo
    read -p'printf "\033[92mid\033[m>\033[97m "' "ID" ; printf "\033[m"
    switch "$ID"
      case ":exit" ":quit" ":q"
        exit
      case ":new" ":n" ":"
        exec tmux -u new-session
      case ":new *"
        set ID (printf "$ID" | sed "s/\:new //")
        exec tmux -u new-session -s "$ID"
      case ":n *"
        set ID (printf "$ID" | sed "s/\:n //")
        exec tmux -u new-session -s "$ID"
      case ":*"
        set ID (printf "$ID" | sed "s/\://")
        exec tmux -u new-session -s "$ID"
      case ""
        exec tmux -u attach-session
      case "*"
        set LIST (tmux list-session | cut -d":" -f1)
        set exist 0
        for i in $LIST
          if test "$i" = "$ID"
            set exist 1
          end
        end
        if test $exist = 1
          exec tmux -u attach-session -t "$ID"
        else
          exec tmux -u new-session -s "$ID"
        end
    end
  end
end
