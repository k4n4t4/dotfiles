
# export
export EDITOR="nvim"
export LANG=C

# tmux
if type -q tmux
and status is-interactive
and not set -q TMUX
  set LIST (tmux list-session) ; clear
  if test -z "$LIST"
    exec tmux -u new-session
  else
    tmux list-session
    echo ":new :n"
    echo ":exit :quit :q"
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
        exec tmux -u attach-session -t "$ID"
    end
  end
end
