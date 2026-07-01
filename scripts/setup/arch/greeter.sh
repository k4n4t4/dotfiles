sudo pacman -S --noconfirm greetd greetd-tuigreet
sudo systemctl enable greetd

sudo sed -i '/^\[default_session\]/,/^\[/ s|^command = .*|command = "tuigreet --time --remember --remember-session"|' /etc/greetd/config.toml
sudo sed -i '/^\[default_session\]/,/^\[/ s|^user = .*|user = "greeter"|' /etc/greetd/config.toml
