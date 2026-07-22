sudo pacman --needed --noconfirm -S zed kitty neovide nautilus mpv firefox thunderbird gimp discord obsidian

xdg-settings set default-web-browser firefox.desktop
xdg-mime default neovide.desktop text/plain
xdg-mime default org.gnome.Nautilus.desktop inode/directory

xdg-mime default mpv.desktop video/mp4
xdg-mime default mpv.desktop video/x-matroska
xdg-mime default mpv.desktop video/webm
xdg-mime default mpv.desktop video/x-msvideo
xdg-mime default mpv.desktop video/quicktime
xdg-mime default mpv.desktop video/mpeg
xdg-mime default mpv.desktop video/x-flv
xdg-mime default mpv.desktop video/x-ms-wmv
xdg-mime default mpv.desktop video/ogg
xdg-mime default mpv.desktop video/3gpp
xdg-mime default mpv.desktop video/3gpp2

xdg-mime default mpv.desktop image/jpeg
xdg-mime default mpv.desktop image/png
xdg-mime default mpv.desktop image/gif
xdg-mime default mpv.desktop image/webp
xdg-mime default gimp.desktop image/x-xcf

xdg-mime default mpv.desktop audio/mpeg
xdg-mime default mpv.desktop audio/flac
xdg-mime default mpv.desktop audio/wav
xdg-mime default mpv.desktop audio/x-wav
xdg-mime default mpv.desktop audio/ogg
xdg-mime default mpv.desktop audio/aac
xdg-mime default mpv.desktop audio/mp4
xdg-mime default mpv.desktop audio/x-m4a
xdg-mime default mpv.desktop audio/opus
xdg-mime default mpv.desktop audio/x-matroska
xdg-mime default mpv.desktop audio/weba

# sudo pacman --needed --noconfirm -S wezterm

# sudo pacman --needed --noconfirm -S ghostty
# git clone https://github.com/sahaj-b/ghostty-cursor-shaders ~/.config/ghostty/shaders
