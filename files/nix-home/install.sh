#!/bin/sh
set -eu

printf %s " name (defaut: common): "
read -r name

case "$name" in ( "" )
  name="common"
esac

nix run home-manager/master -- switch --flake .#"$name"
