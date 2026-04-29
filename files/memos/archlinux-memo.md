# My Arch Linux Environments

> packages
```bash
# System
sudo pacman -S linux-firmware sof-firmware efibootmgr os-prober grub base-devel
# GUI
sudo pacman -S hyprland hyprlock hypridle hyprshot waybar wofi uwsm xdg-utils mako libnotify
# Network
sudo pacman -S networkmanager network-manager-applet
# Bluetooth
sudo pacman -S bluez bluez-utils blueman
# Audio
sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol
# Power Management
sudo pacman -S power-profiles-daemon
# Applications
sudo pacman -S kitty firefox
# Fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd
# Japanese Input Method
sudo pacman -S fcitx5-im fcitx5-mozc
# CLI Tools
sudo pacman -S git git-delta github-cli fzf fd ripgrep zoxide eza bat btop htop trash-cli wget curl unzip zip less man-db wl-clipboard tree-sitter-cli fish starship neovim nodejs npm

# Display Manager
sudo pacman -S sddm qt6-svg qt6-virtualkeyboard
sudo systemctl enable sddm
```
