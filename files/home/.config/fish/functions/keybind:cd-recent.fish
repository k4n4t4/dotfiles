function keybind:cd-recent --description "Change to recent directory from cd history"
    if type -q cd:recent
        set -l dir (cd:recent | fzf --preview 'ls -lah {} 2>/dev/null | head -20')
        if test -n "$dir"
            cd "$dir"
            commandline -f repaint
        end
    else
        echo "cd:recent function not available"
    end
end
