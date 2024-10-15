#!/bin/sh
set -eu

cat > /tmp/kitty_scrollback_buffer

INPUT_LINE_NUMBER="${1:-}" \
CURSOR_LINE="${2:-}" \
CURSOR_COLUMN="${3:-}" \
nvim -u ~/.config/kitty/pager.lua
