# hyprland
sudo pacman --needed --noconfirm -S hyprland uwsm xdg-utils xdg-desktop-portal-hyprland wl-clipboard
sudo pacman --needed --noconfirm -S pipewire pipewire-jack pipewire-alsa pipewire-pulse wireplumber


sudo pacman --needed --noconfirm -S fcitx5-im fcitx5-mozc

# fonts
sudo pacman --needed --noconfirm -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-font-awesome
sudo pacman --needed --noconfirm -S ttf-jetbrains-mono-nerd ttf-firacode-nerd

# noctalia
sudo pacman --needed --noconfirm -S noctalia
sudo pacman --needed --noconfirm -S socat
sudo pacman --needed --noconfirm -S libnotify
sudo pacman --needed --noconfirm -S mate-polkit
sudo pacman --needed --noconfirm -S bluez bluez-utils
sudo systemctl enable bluetooth
sudo pacman --needed --noconfirm -S brightnessctl
sudo pacman --needed --noconfirm -S power-profiles-daemon
sudo pacman --needed --noconfirm -S libsecret gnome-keyring seahorse
