sudo pacman --needed --noconfirm -S greetd greetd-regreet cage
sudo systemctl enable greetd

sudo cp -v "$SCRIPTS_DIR/setup/arch/greetd/"* /etc/greetd/

grep -qF 'pam_gnome_keyring' /etc/pam.d/greetd || printf '\nauth       optional     pam_gnome_keyring.so\nsession    optional     pam_gnome_keyring.so auto_start\n' | sudo tee -a /etc/pam.d/greetd > /dev/null
