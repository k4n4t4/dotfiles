sudo pacman -S sddm qt6-svg qt6-virtualkeyboard
sudo systemctl enable sddm
sudo git clone https://github.com/MarianArlt/sddm-sugar-dark.git /usr/share/sddm/themes/sddm-sugar-dark
sudo pacman -S qt5-graphicaleffects qt5-quickcontrols2
sudo mkdir -p /etc/sddm.conf.d
echo -e "[Theme]\nCurrent=sddm-sugar-dark" | sudo tee /etc/sddm.conf.d/10-theme.conf
