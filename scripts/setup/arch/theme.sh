sudo pacman --needed --noconfirm -S nwg-look adw-gtk-theme

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'


sudo pacman --needed --noconfirm -S capitaine-cursors

mkdir -p ~/.config/environment.d
touch ~/.config/environment.d/cursor.conf
grep -q '^XCURSOR_THEME=' ~/.config/environment.d/cursor.conf && sed -i 's|^XCURSOR_THEME=.*|XCURSOR_THEME=capitaine-cursors|' ~/.config/environment.d/cursor.conf || echo 'XCURSOR_THEME=capitaine-cursors' >> ~/.config/environment.d/cursor.conf
grep -q '^XCURSOR_SIZE=' ~/.config/environment.d/cursor.conf && sed -i 's|^XCURSOR_SIZE=.*|XCURSOR_SIZE=36|' ~/.config/environment.d/cursor.conf || echo 'XCURSOR_SIZE=36' >> ~/.config/environment.d/cursor.conf

sudo pacman --needed --noconfirm -S tela-circle-icon-theme-all

gsettings set org.gnome.desktop.interface icon-theme 'Tela-circle-grey-dark'
