function tmux-start
  if not type -q tmux
    echo "`tmux` is not installed." >&2
    return 1
  end
  if not status is-interactive
    echo "Is not interactive." >&2
    return 1
  end
  if set -q TMUX
    echo "Already in tmux." >&2
    return 1
  end

  if set -f TMUX_SESSION_LIST (tmux list-session 2> /dev/null)

    printf "%s%s%s\n" (whoami) "@" (hostname)
    hr =
    for i in $TMUX_SESSION_LIST
      echo $i
    end
    hr =
    read -f -p 'printf " \033[92mid\033[90m > \033[97m"' ID ; printf "\033[m"

    switch "$ID"
      case ":exit" ":quit" ":q"
        return 0
      case ""
        tmux -u attach-session
        return 0
      case "*"
        set -f TMUX_SESSION_ID_LIST (string replace -r ":.*" "" $TMUX_SESSION_LIST)
        for i in $TMUX_SESSION_ID_LIST
          if test "$i" = "$ID"
            tmux -u attach-session -t "$ID"
            return 0
          end
        end
        tmux -u new-session -s "$ID"
        return 0
    end
  else

    tmux -u new-session $argv
    return 0

  end

end
