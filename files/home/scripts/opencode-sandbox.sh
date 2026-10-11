#!/bin/sh
set -eu

[ -n "${SANDBOXED:-}" ] || SANDBOXED=1 exec unshare --user --map-root-user --mount --pid --fork --kill-child "$0" "$@"

cwd=$PWD
r=/mnt

mount -t tmpfs tmpfs "$r"
mkdir -p "$r/usr" "$r/etc" "$r/proc" "$r/dev" "$r/tmp" "$r/.old"
mount --rbind /usr "$r/usr"
mount --rbind /etc "$r/etc"
mount --rbind /dev "$r/dev"
mount -t proc proc "$r/proc"
ln -s usr/bin "$r/bin"
ln -s usr/lib "$r/lib"
ln -s usr/lib "$r/lib64"

for d in "$cwd" "$HOME/.local/share/opencode" "$HOME/.local/state/opencode" "$HOME/.cache/opencode" "$HOME/.config/opencode" /run/systemd/resolve; do
    mkdir -p "$r$d"
    mount --rbind "$d" "$r$d"
done

cd "$r"
pivot_root . .old
umount -l /.old
cd "$cwd"
exec opencode --standalone "$@"
