GPU_INFO="$(lspci | grep -E -i "(vga compatible controller|3d controller|display controller)" | tr '[:upper:]' '[:lower:]')"

case "$GPU_INFO" in ( *"nvidia"* )
    sudo pacman --needed --noconfirm -S nvidia-open-dkms nvidia-utils
esac

case "$GPU_INFO" in ( *"intel"* )
    sudo pacman --needed --noconfirm -S mesa vulkan-intel intel-media-driver vpl-gpu-rt
esac

case "$GPU_INFO" in ( *"amd"* )
    sudo pacman --needed --noconfirm -S mesa vulkan-radeon xf86-video-amdgpu
esac
