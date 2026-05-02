# My Arch Linux Environments

> packages
```bash
# System
sudo pacman -S linux-firmware sof-firmware efibootmgr os-prober grub base-devel

# CLI Tools
sudo pacman -S git git-delta github-cli fzf fd ripgrep zoxide eza bat btop htop trash-cli wget curl unzip zip less man-db wl-clipboard tree-sitter-cli fish starship neovim nodejs npm

# yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
makepkg -D /tmp/yay -si

# GUI AUR
yay -S hyprland-git
yay -S wlogout

# GUI
sudo pacman -S hyprlock hypridle hyprshot waybar wofi uwsm xdg-utils mako libnotify gnome-themes-extra awww
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark

# Network
sudo pacman -S networkmanager network-manager-applet

# Bluetooth
sudo pacman -S bluez bluez-utils blueman

# Audio
sudo pacman -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol

# Backlight
sudo pacman -S brightnessctl

# Power Management
sudo pacman -S power-profiles-daemon

# Applications
sudo pacman -S kitty firefox obsidian discord gimp

# Applications AUR
yay -S st

# Fonts
sudo pacman -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd

# Japanese Input Method
sudo pacman -S fcitx5-im fcitx5-mozc

# Display Manager
sudo pacman -S sddm qt6-svg qt6-virtualkeyboard
sudo systemctl enable sddm
sudo git clone https://github.com/MarianArlt/sddm-sugar-dark.git /usr/share/sddm/themes/sddm-sugar-dark
sudo pacman -S qt5-graphicaleffects qt5-quickcontrols2
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=sddm-sugar-dark" | sudo tee /etc/sddm.conf.d/10-theme.conf

# Virus Scanner
sudo pacman -S clamav
sudo freshclam

# intel
sudo pacman -S intel-media-driver mesa
sudo pacman -S mesa-utils

# intel GPU
sudo pacman -S vulkan-tools vulkan-intel intel-compute-runtime

# Local LLM
curl -fsSL https://ollama.com/install.sh | sh
sudo systemctl enable --now ollama
sudo pacman -S opencode

# enable Vulkan support for Ollama
echo -e "[Service]\nEnvironment=\"OLLAMA_VULKAN=1\"" | sudo tee /etc/systemd/system/ollama.service.d/override.conf
```
