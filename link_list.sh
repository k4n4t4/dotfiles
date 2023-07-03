#!/bin/sh
set -eu

info "===== bin (total: $(cat "lists/bin" | wc -l)) ====="
read_link_list "lists/bin"

for path in lists/*; do
  file="$(basename "$path")"
  if cmd_exist "$file" || [ "$file" = "bin" ]; then
    info "===== $file (total: $(cat "$path" | wc -l)) ====="
    read_link_list "$path"
  fi
done
