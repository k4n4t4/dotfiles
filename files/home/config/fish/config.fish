if status is-interactive
    set -gx FISH_DIR (dirname (status --current-filename))
    set -gx FISH_BIN (which fish)

    source $FISH_DIR/settings.fish
    source $FISH_DIR/aliases.fish

    if test -f ~/.rc.fish
        # @fish-lsp-disable-next-line
        source ~/.rc.fish
    end
end
