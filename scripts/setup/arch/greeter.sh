# greeter
sudo pacman --needed --noconfirm -S sddm
sudo systemctl enable sddm

SDDM_THEME_NAME="MySddmTheme"

if ! [ -d "/usr/share/sddm/themes" ]; then
    sudo mkdir -p "/usr/share/sddm/themes"
fi

if [ -d "$SCRIPTS_DIR/setup/arch/sddm/$SDDM_THEME_NAME" ]; then
    sudo cp -r "$SCRIPTS_DIR/setup/arch/sddm/$SDDM_THEME_NAME" "/usr/share/sddm/themes/"

    if ! [ -d "/etc/sddm.conf.d" ]; then
        sudo mkdir -p "/etc/sddm.conf.d"
    fi

    printf '[Theme]\nCurrent=%s\n' "$SDDM_THEME_NAME" | sudo tee "/etc/sddm.conf.d/theme.conf" > /dev/null
fi
