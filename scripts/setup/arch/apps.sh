sudo pacman --needed --noconfirm -S zed kitty neovide nautilus mpv firefox thunderbird gimp discord obsidian


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
xdg-mime default neovide.desktop text/plain
xdg-mime default org.gnome.Nautilus.desktop inode/directory

for mime in video/mp4 video/x-matroska video/webm video/x-msvideo video/quicktime video/mpeg video/x-flv video/x-ms-wmv video/ogg video/3gpp video/3gpp2 \
  image/jpeg image/png image/gif image/webp \
  audio/mpeg audio/flac audio/wav audio/x-wav audio/ogg audio/aac audio/mp4 audio/x-m4a audio/opus audio/x-matroska audio/weba
do
  xdg-mime default mpv.desktop "$mime"
done

xdg-mime default gimp.desktop image/x-xcf
