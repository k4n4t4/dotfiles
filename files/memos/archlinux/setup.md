# My Arch Linux Environments

> packages
```bash
# System
sudo pacman -S --noconfirm linux-firmware sof-firmware efibootmgr dosfstools ntfs-3g base-devel
sudo pacman -S --noconfirm vim git htop wget curl unzip zip less man-db

# CLI Tools
sudo pacman -S --noconfirm git-delta github-cli fzf fd ripgrep zoxide eza bat btop trash-cli wl-clipboard tree-sitter-cli fish starship neovim nodejs npm fastfetch 7zip
sudo npm install -g @github/copilot

# Virus Scanner
sudo pacman --noconfirm -S clamav
sudo freshclam

# yay
git clone https://aur.archlinux.org/yay.git /tmp/yay
makepkg --noconfirm -D /tmp/yay -si


use_hyprland=false
use_niri=true

if $use_hyprland; then
    # GUI hyprland
    sudo pacman --noconfirm -S hyprland uwsm xdg-utils xdg-desktop-portal-hyprland hyprlock hypridle hyprshot swayosd waybar wofi awww
    sudo pacman --noconfirm -S mako libnotify
    sudo pacman --noconfirm -S networkmanager network-manager-applet
    sudo pacman --noconfirm -S bluez bluez-utils blueman
    sudo pacman --noconfirm -S mate-polkit
    sudo pacman --noconfirm -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol
    sudo pacman --noconfirm -S brightnessctl
    sudo pacman --noconfirm -S power-profiles-daemon
    sudo pacman --noconfirm -S libsecret gnome-keyring seahorse
    sudo pacman --noconfirm -S fcitx5-im fcitx5-mozc
    sudo pacman --noconfirm -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd
    yay -S wlogout
fi

if $use_niri; then
    # GUI niri
    sudo pacman --noconfirm -Syu uwsm niri xwayland-satellite xdg-desktop-portal-gnome xdg-desktop-portal-gtk dms-shell-niri matugen cava qt6-multimedia-ffmpeg polkit
    sudo pacman --noconfirm -S libnotify
    sudo pacman --noconfirm -S networkmanager network-manager-applet
    sudo pacman --noconfirm -S bluez bluez-utils blueman
    sudo systemctl enable bluetooth
    sudo pacman --noconfirm -S brightnessctl
    sudo pacman --noconfirm -S pipewire pipewire-alsa pipewire-jack pipewire-pulse wireplumber pavucontrol
    sudo pacman --noconfirm -S power-profiles-daemon
    sudo pacman --noconfirm -S libsecret gnome-keyring seahorse
    sudo pacman --noconfirm -S fcitx5-im fcitx5-mozc
    sudo pacman --noconfirm -S noto-fonts noto-fonts-cjk noto-fonts-emoji ttf-dejavu ttf-font-awesome ttf-jetbrains-mono-nerd
    yay -Syuu noctalia-git
fi


# Applications
sudo pacman --noconfirm -S kitty firefox obsidian discord gimp vlc

# latex
sudo pacman --noconfirm -S texlive-basic texlive-latex texlive-latexrecommended texlive-latexextra texlive-fontsrecommended texlive-fontsextra texlive-luatex texlive-langcjk texlive-langjapanese

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
