#!/bin/sh
set -eu

printf %s " name (defaut: desktop): "
read -r name

case "$name" in ( "" )
  name="desktop"
esac

nix run home-manager/master -- switch --flake .#"$name"
