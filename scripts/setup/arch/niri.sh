sudo pacman --needed --noconfirm -Syu uwsm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk dms-shell-niri matugen cava qt6-multimedia-ffmpeg polkit
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
yay --needed --noconfirm -Syuu noctalia-git
