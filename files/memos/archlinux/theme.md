
# GTK Theme
~~~bash
sudo pacman -S gnome-themes-extra
gsettings set org.gnome.desktop.interface gtk-theme "Adwaita-dark"
gsettings set org.gnome.desktop.interface color-scheme prefer-dark
~~~

# Qt Theme
~~~bash
sudo pacman -S kvantum qt6ct
mkdir -p ~/.config/qt6ct
echo -e "[Appearance]\nstyle=kvantum-dark" | tee ~/.config/qt6ct/qt6ct.conf
kvantummanager --set KvAmbiance
~~~
