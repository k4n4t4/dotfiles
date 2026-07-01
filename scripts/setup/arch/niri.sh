sudo pacman --needed --noconfirm -Syu uwsm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk dms-shell-niri matugen cava qt6-multimedia-ffmpeg polkit

if [ -f /usr/share/wayland-sessions/niri.desktop ]; then
    if ! [ -f /usr/share/wayland-sessions/niri-uwsm.desktop ]; then
        sudo cp /usr/share/wayland-sessions/niri.desktop /usr/share/wayland-sessions/niri-uwsm.desktop
        sudo sed -i 's/^Name=Niri$/Name=Niri (uwsm)/' "/usr/share/wayland-sessions/niri-uwsm.desktop"
        sudo sed -i 's/^Exec=niri-session$/Exec=uwsm start niri-session/' "/usr/share/wayland-sessions/niri-uwsm.desktop"
    fi
fi

sudo pacman --needed --noconfirm -S libnotify
sudo pacman --needed --noconfirm -S networkmanager
sudo pacman --needed --noconfirm -S bluez bluez-utils
sudo systemctl enable bluetooth
sudo pacman --needed --noconfirm -S brightnessctl
if pacman -Qq jack2 &> /dev/null; then
    sudo pacman --noconfirm -Rdd jack2
fi
sudo pacman --needed --noconfirm -S pipewire-jack
sudo pacman --needed --noconfirm -S pipewire pipewire-alsa pipewire-pulse wireplumber
sudo pacman --needed --noconfirm -S power-profiles-daemon
sudo pacman --needed --noconfirm -S libsecret gnome-keyring seahorse
sudo pacman --needed --noconfirm -S fcitx5-im fcitx5-mozc
sudo pacman --needed --noconfirm -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd
yay --needed --noconfirm -S noctalia-git
