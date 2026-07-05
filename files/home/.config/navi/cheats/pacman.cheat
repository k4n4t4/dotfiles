% pacman cheat

# pacman enable pacman of pacman
sudo sed -i -e '/^\[options\]/,/^\[/ { /ILoveCandy/d }' -e '/^\[options\]/a ILoveCandy' /etc/pacman.conf

# pacman disable pacman of pacman
sudo sed -i -e '/^\[options\]/,/^\[/ { /^ILoveCandy/d; /^#ILoveCandy/d }' -e '/^\[options\]/a #ILoveCandy' /etc/pacman.conf

# pacman remove orphan packages
sudo pacman -Rns $(pacman -Qdtq)

# pacman remove cache packages
sudo pacman -Sc

# pacman remove cache packages all
sudo pacman -Scc

# pacman update
sudo pacman -Syu
