sudo pacman --noconfirm -Syu uwsm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk dms-shell-niri matugen cava qt6-multimedia-ffmpeg polkit
sudo pacman --noconfirm -S libnotify
sudo pacman --noconfirm -S networkmanager
sudo pacman --noconfirm -S bluez bluez-utils
sudo systemctl enable bluetooth
sudo pacman --noconfirm -S brightnessctl
sudo pacman --noconfirm -Rdd jack2
sudo pacman --noconfirm -S pipewire-jack
sudo pacman --noconfirm -S pipewire pipewire-alsa pipewire-pulse wireplumber
sudo pacman --noconfirm -S power-profiles-daemon
sudo pacman --noconfirm -S libsecret gnome-keyring seahorse
sudo pacman --noconfirm -S fcitx5-im fcitx5-mozc
sudo pacman --noconfirm -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd
yay -Syuu noctalia-git
