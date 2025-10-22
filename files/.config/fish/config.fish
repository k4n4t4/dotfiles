# @fish-lsp-disable

if status is-interactive
  export FISH_DIR=(dirname (status --current-filename))
  export FISH_BIN=(which fish)

  source $FISH_DIR/settings.fish
  source $FISH_DIR/aliases.fish

  if test -f ~/.rc.fish
    source ~/.rc.fish
  end
end
