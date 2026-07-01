~~~bash
sudo pacman -S qemu-full libvirt virt-install virt-manager virt-viewer edk2-ovmf dnsmasq tuned ntfs-3g swtpm

sudo systemctl enable libvirtd.service


~~~

`sudo vim /etc/libvirt/libvirtd.conf` and uncomment this

~~~
unix_sock_group = "libvirt"
unix_sock_rw_perms = "0770"
~~~

~~~bash
sudo usermod -a -G libvirt $(whoami)
newgrp libvirt

sudo virsh net-start default
sudo virsh net-autostart default
~~~
