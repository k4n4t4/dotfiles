sudo pacman --needed --noconfirm -S greetd greetd-tuigreet
sudo systemctl enable greetd

sudo sed -i '/^\[default_session\]/,/^\[/ s|^command = .*|command = "tuigreet --time --remember --remember-session --user-menu --cmd '"'"'uwsm start niri.desktop'"'"'"|' /etc/greetd/config.toml
sudo sed -i '/^\[default_session\]/,/^\[/ s|^user = .*|user = "greeter"|' /etc/greetd/config.toml

grep -qF 'pam_gnome_keyring' /etc/pam.d/greetd || printf '\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start\n' | sudo tee -a /etc/pam.d/greetd > /dev/null
