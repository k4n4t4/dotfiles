function keybind:file-browser --description "Browse files and insert path"
    set -l file (fd -H --type f 2>/dev/null | fzf --preview 'bat --style=numbers --color=always --line-range :300 {} 2>/dev/null')
    if test -n "$file"
        commandline -i "$file"
    end
end
