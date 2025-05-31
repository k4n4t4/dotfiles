#!/bin/sh
set -eu

printf %s " name (defaut: nixos): "
read -r name

case "$name" in ( "" )
  name="nixos"
esac

sudo nixos-rebuild switch --flake .#"$name"
