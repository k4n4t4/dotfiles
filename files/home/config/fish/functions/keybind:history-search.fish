function keybind:history-search --description "Search command history"
    set -l cmd (history | fzf --preview-window=hidden --query=(commandline))
    if test -n "$cmd"
        commandline "$cmd"
        commandline -f execute
    end
end
