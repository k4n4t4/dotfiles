function keybind:git-status --description "Show git status in fzf"
    if git rev-parse --git-dir > /dev/null 2>&1
        git -c color.status=always status --short | fzf --ansi --preview 'git diff {2} 2>/dev/null' --bind 'enter:execute(echo {2} | xargs -I {} git add {})' > /dev/null 2>&1
        commandline -f repaint
    else
        echo "Not in a git repository"
    end
end
