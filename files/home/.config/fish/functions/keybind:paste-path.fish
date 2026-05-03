function keybind:paste-path --description "Paste path using fzf"
    set -l path (fd -H 2>/dev/null | fzf --preview 'if test -d {}; ls -lah {} 2>/dev/null; else bat --style=numbers --color=always {} 2>/dev/null; end' --preview-window=right:50%)
    if test -n "$path"
        commandline -i "$path"
    end
end
