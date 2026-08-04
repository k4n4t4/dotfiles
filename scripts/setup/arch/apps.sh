sudo pacman --needed --noconfirm -S zed kitty nautilus mpv firefox thunderbird gimp discord obsidian


if ! [ -d /usr/share/applications ]; then
    sudo mkdir -p /usr/share/applications
fi
if ! [ -e /usr/share/applications/kitty-nvim.desktop ]; then
    sudo cp "$SCRIPTS_DIR/setup/arch/desktop-files/kitty-nvim.desktop" /usr/share/applications/
fi
if [ -f /usr/share/applications/nvim.desktop ]; then
    sudo rm /usr/share/applications/nvim.desktop
fi

xdg-settings set default-web-browser firefox.desktop
xdg-mime default kitty-nvim.desktop text/plain
xdg-mime default org.gnome.Nautilus.desktop inode/directory

for mime in $(grep ^MimeType= /usr/share/applications/mpv.desktop | cut -d= -f2 | tr ';' ' '); do
    xdg-mime default mpv.desktop "$mime"
done
for mime in $(grep ^MimeType= /usr/share/applications/gimp.desktop | cut -d= -f2 | tr ';' ' '); do
    xdg-mime default gimp.desktop "$mime"
done
for mime in image/jpeg image/png image/gif image/webp; do
    xdg-mime default mpv.desktop "$mime"
done
