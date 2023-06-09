#!/bin/sh
set -eu

echo
if type "code" > /dev/null 2>&1; then
  while read line ; do
    code --install-extension "${line}"
    echo
  done < extensions
elif type "codium" > /dev/null 2>&1; then
  while read line ; do
    codium --install-extension "${line}"
    echo
  done < extensions
fi

