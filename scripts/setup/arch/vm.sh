sudo pacman -S --noconfirm qemu-full libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq tuned ntfs-3g swtpm
sudo systemctl enable libvirtd.service


sudo sed -i -e 's/^#unix_sock_group = "libvirt"/unix_sock_group = "libvirt"/' -e 's/^#unix_sock_rw_perms = "0770"/unix_sock_rw_perms = "0770"/' /etc/libvirt/libvirtd.conf

sudo usermod -a -G libvirt $(whoami)
newgrp libvirt

sudo virsh net-start default
sudo virsh net-autostart default
