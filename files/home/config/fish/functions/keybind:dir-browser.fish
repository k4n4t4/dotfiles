function keybind:dir-browser --description "Browse directories and cd"
    set -l dir (fd --type d -H 2>/dev/null | fzf --preview 'ls -lah {} 2>/dev/null | head -20')
    if test -n "$dir"
        cd "$dir"
        commandline -f repaint
    end
end
