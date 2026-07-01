mkdir -p /tmp/cachyos-repo
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o /tmp/cachyos-repo/cachyos-repo.tar.xz
tar xvf /tmp/cachyos-repo/cachyos-repo.tar.xz -C /tmp/cachyos-repo --strip-components=1
sudo /tmp/cachyos-repo/cachyos-repo.sh

grep -q "^\[cachyos\]" /etc/pacman.conf || { grep -q "^#\[cachyos\]" /etc/pacman.conf && sudo sed -i 's/^#\[cachyos\]/[cachyos]/; s/^#Include = \/etc\/pacman.d\/cachyos-mirrorlist/Include = \/etc\/pacman.d\/cachyos-mirrorlist/' /etc/pacman.conf || echo -e "\n[cachyos]\nInclude = /etc/pacman.d/cachyos-mirrorlist" | sudo tee -a /etc/pacman.conf > /dev/null; }

sudo pacman --noconfirm -Syuu
