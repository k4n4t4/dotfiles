sudo pacman --needed --noconfirm -S hyprland uwsm xdg-utils xdg-desktop-portal-hyprland hyprshot
sudo pacman --needed --noconfirm -S libnotify
sudo pacman --needed --noconfirm -S networkmanager
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
yay --needed --noconfirm -S noctalia-git
