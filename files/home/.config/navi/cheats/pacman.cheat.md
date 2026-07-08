% pacman

# enable pacman of pacman
sudo sed -i -e '/^\[options\]/,/^\[/ { /ILoveCandy/d }' -e '/^\[options\]/a ILoveCandy' /etc/pacman.conf

# disable pacman of pacman
sudo sed -i -e '/^\[options\]/,/^\[/ { /^ILoveCandy/d; /^#ILoveCandy/d }' -e '/^\[options\]/a #ILoveCandy' /etc/pacman.conf

# remove orphan packages
sudo pacman -Rns $(pacman -Qdtq)

# remove cache packages
sudo pacman -Sc

# remove cache packages all
sudo pacman -Scc

# update
sudo pacman -Syu
