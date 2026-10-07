# sddm theme
SDDM_THEME_NAME="MySddmTheme"
CURSOR_THEME_NAME="MyCursor"
CURSOR_SIZE=32

if [ -d "$SCRIPTS_DIR/setup/arch/sddm/$SDDM_THEME_NAME" ]; then
    sudo mkdir -p "/usr/share/sddm/themes"
    sudo cp -r "$SCRIPTS_DIR/setup/arch/sddm/$SDDM_THEME_NAME" "/usr/share/sddm/themes/"
fi

if [ -d "$SCRIPTS_DIR/setup/arch/cursor/$CURSOR_THEME_NAME" ]; then
    sudo mkdir -p "/usr/share/icons"
    sudo cp -r "$SCRIPTS_DIR/setup/arch/cursor/$CURSOR_THEME_NAME" "/usr/share/icons/"
fi

sudo mkdir -p "/usr/share/icons/default"
printf '[Icon Theme]\nInherits=%s\n' \
    "$CURSOR_THEME_NAME" |
    sudo tee "/usr/share/icons/default/index.theme" > /dev/null

sudo mkdir -p "/etc/sddm.conf.d"
printf '[Theme]\nCurrent=%s\nCursorTheme=%s\nCursorSize=%s\n' \
    "$SDDM_THEME_NAME" \
    "$CURSOR_THEME_NAME" \
    "$CURSOR_SIZE" |
    sudo tee "/etc/sddm.conf.d/theme.conf" > /dev/null
