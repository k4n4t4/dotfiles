yay --needed --noconfirm -S mangowm-git

if [ -f /usr/share/wayland-sessions/mango.desktop ]; then
    if ! [ -f /usr/share/wayland-sessions/mango-uwsm.desktop ]; then
        sudo cp /usr/share/wayland-sessions/mango.desktop /usr/share/wayland-sessions/mango-uwsm.desktop
        sudo sed -i 's/^Name=Mango$/Name=Mango (uwsm)/' "/usr/share/wayland-sessions/mango-uwsm.desktop"
        sudo sed -i 's/^Exec=mango$/Exec=uwsm start mango/' "/usr/share/wayland-sessions/mango-uwsm.desktop"
    fi
fi

yay --needed --noconfirm -S noctalia-git
sudo pacman --needed --noconfirm -S uwsm
sudo pacman --needed --noconfirm -S xdg-utils
sudo pacman --needed --noconfirm -S socat
sudo pacman --needed --noconfirm -S libnotify

sudo pacman --needed --noconfirm -S iwd
sudo systemctl enable --now iwd.service

sudo pacman --needed --noconfirm -S bluez bluez-utils
sudo systemctl enable bluetooth

sudo pacman --needed --noconfirm -S mate-polkit

if pacman -Qq jack2 &> /dev/null; then
    sudo pacman --noconfirm -Rdd jack2
fi
sudo pacman --needed --noconfirm -S pipewire-jack
sudo pacman --needed --noconfirm -S pipewire pipewire-alsa pipewire-pulse wireplumber

sudo pacman --needed --noconfirm -S brightnessctl

sudo pacman --needed --noconfirm -S power-profiles-daemon

sudo pacman --needed --noconfirm -S libsecret gnome-keyring seahorse

sudo pacman --needed --noconfirm -S fcitx5-im fcitx5-mozc

sudo pacman --needed --noconfirm -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome
sudo pacman --needed --noconfirm -S ttf-jetbrains-mono-nerd
