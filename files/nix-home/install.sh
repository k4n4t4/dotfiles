#!/bin/sh
set -eu

printf %s " name (defaut: desktop): "
read -r name

if [ "$name" = "" ]; then
  name="desktop"
fi

nix run home-manager/master -- switch --flake .#"$name"
