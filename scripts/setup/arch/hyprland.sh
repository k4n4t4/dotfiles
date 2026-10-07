# hyprland
sudo pacman --needed --noconfirm -S \
    hyprland \
    uwsm \
    xdg-utils \
    xdg-desktop-portal-hyprland \
    wl-clipboard

# audio
sudo pacman --needed --noconfirm -S \
    pipewire \
    pipewire-jack \
    pipewire-alsa \
    pipewire-pulse \
    wireplumber


# input method
sudo pacman --needed --noconfirm -S \
    fcitx5-im \
    fcitx5-mozc

# fonts
sudo pacman --needed --noconfirm -S \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    ttf-font-awesome

# nerd fonts
sudo pacman --needed --noconfirm -S \
    ttf-jetbrains-mono-nerd \
    ttf-firacode-nerd

# noctalia
sudo pacman --needed --noconfirm -S \
    noctalia \
    socat \
    libnotify \
    bluez \
    power-profiles-daemon \
    mate-polkit \
    libsecret gnome-keyring seahorse
sudo systemctl enable bluetooth

# greeter
sudo pacman --needed --noconfirm -S sddm
sudo systemctl enable sddm
