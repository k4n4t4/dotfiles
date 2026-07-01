mkdir -p /tmp/cachyos-repo
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o /tmp/cachyos-repo/cachyos-repo.tar.xz
tar xvf /tmp/cachyos-repo/cachyos-repo.tar.xz -C /tmp/cachyos-repo --strip-components=1
sudo /tmp/cachyos-repo/cachyos-repo.sh
sudo pacman --noconfirm -Syuu
