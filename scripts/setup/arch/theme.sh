sudo pacman --needed --noconfirm -S nwg-look adw-gtk-theme

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3'

sudo pacman --needed --noconfirm -S capitaine-cursors

gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors'
gsettings set org.gnome.desktop.interface cursor-size 96
