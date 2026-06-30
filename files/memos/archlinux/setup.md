# My Arch Linux Environments

> packages
```bash
# System
sudo pacman -S linux-firmware sof-firmware efibootmgr dosfstools ntfs-3g base-devel

# CLI Tools
sudo pacman -S git git-delta github-cli fzf fd ripgrep zoxide eza bat btop htop trash-cli wget curl unzip zip less man-db wl-clipboard tree-sitter-cli fish starship neovim nodejs npm yazi fastfetch

# yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
makepkg -D /tmp/yay -si


# GUI hyprland
sudo pacman -S hyprland uwsm xdg-utils xdg-desktop-portal-hyprland hyprlock hypridle hyprshot swayosd waybar wofi awww
yay -S wlogout

# Notification Daemon
sudo pacman -S mako libnotify

# Network
sudo pacman -S networkmanager network-manager-applet

# Bluetooth
sudo pacman -S bluez bluez-utils blueman

# Authentication Agent
sudo pacman -S mate-polkit

# Audio
sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol

# Backlight
sudo pacman -S brightnessctl

# Power Management
sudo pacman -S power-profiles-daemon

# Secure Storage
sudo pacman -S libsecret gnome-keyring seahorse


# GUI niri
sudo pacman -Syu uwsm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk dms-shell-niri matugen cava qt6-multimedia-ffmpeg polkit
yay -Syuu noctalia-git
sudo pacman -S libnotify
sudo pacman -S networkmanager network-manager-applet
sudo pacman -S bluez bluez-utils blueman
sudo pacman -S brightnessctl
sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol
sudo pacman -S power-profiles-daemon
sudo pacman -S libsecret gnome-keyring seahorse


# Applications
sudo pacman -S kitty firefox obsidian discord gimp vlc

# Virus Scanner
sudo pacman -S clamav
sudo freshclam

# latex
sudo pacman -S texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended texlive-fontsextra texlive-luatex texlive-langcjk texlive-langjapanese

# 7zip
sudo pacman -S 7zip

# Fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd

# Github Copilot CLI
sudo npm install -g @github/copilot

# Japanese Input Method
sudo pacman -S fcitx5-im fcitx5-mozc

# Display Manager
sudo pacman -S sddm qt6-svg qt6-virtualkeyboard
sudo systemctl enable sddm
sudo git clone https://github.com/MarianArlt/sddm-sugar-dark.git /usr/share/sddm/themes/sddm-sugar-dark
sudo pacman -S qt5-graphicaleffects qt5-quickcontrols2
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=sddm-sugar-dark" | sudo tee /etc/sddm.conf.d/10-theme.conf

# GTK Theme
sudo pacman -S gnome-themes-extra
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# Qt Theme
sudo pacman -S kvantum qt6ct
mkdir -p ~/.config/qt6ct
echo -e "[Appearance]\nstyle=kvantum-dark" | tee ~/.config/qt6ct/qt6ct.conf
kvantummanager --set KvAmbiance

# nvidia
# add option: nvidia_drm.modeset=1
# if using limine, then add option to /boot/limine/limine.conf
sudo pacman -S nvidia-open

# intel
sudo pacman -S intel-media-driver mesa
sudo pacman -S mesa-utils

# intel GPU
sudo pacman -S vulkan-tools vulkan-intel intel-compute-runtime
```
