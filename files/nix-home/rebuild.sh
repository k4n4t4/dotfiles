#!/bin/sh
set -eu

sudo nixos-rebuild switch --flake .
