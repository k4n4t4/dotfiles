if ! cmd_exist yay; then
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    makepkg --noconfirm -D /tmp/yay -si
fi
