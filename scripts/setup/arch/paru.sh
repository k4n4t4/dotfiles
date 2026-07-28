if ! cmd_exists paru; then
    git clone https://aur.archlinux.org/paru.git /tmp/paru
    makepkg --noconfirm -D /tmp/paru -si
fi
