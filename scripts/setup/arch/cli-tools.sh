# tools
sudo pacman --needed --noconfirm -S \
    fish \
    starship \
    tmux \
    fastfetch \
    eza \
    bat \
    btop \
    trash-cli \
    zoxide \
    fd \
    ripgrep \
    fzf \
    jq \
    github-cli \
    lazygit \
    git-delta \
    7zip \
    podman \
    pandoc-cli \
    opencode

# neovim
sudo pacman --needed --noconfirm -S \
    neovim \
    tree-sitter-cli \
    luarocks \
    imagemagick \
    lldb \
    nodejs \
    npm \
    texlive-latexextra \
    texlive-fontsrecommended

# rust
if ! pacman -Q rust >/dev/null 2>&1; then
    sudo pacman --needed --noconfirm -S rust
fi

# nix
sudo pacman --needed --noconfirm -S nix
if [ ! -f /etc/nix/nix.conf ]; then
    sudo mkdir -p /etc/nix
    sudo touch /etc/nix/nix.conf
fi
if ! sudo grep -qE '^[[:space:]]*experimental-features[[:space:]]*=' /etc/nix/nix.conf; then
    echo 'experimental-features = nix-command flakes' |
        sudo tee -a /etc/nix/nix.conf >/dev/null
else
    for feature in nix-command flakes; do
        if ! sudo grep -E '^[[:space:]]*experimental-features[[:space:]]*=' /etc/nix/nix.conf |
             grep -qw "$feature"; then
            sudo sed -i -E \
                '/^[[:space:]]*experimental-features[[:space:]]*=/ s/[[:space:]]*$/ '"$feature"'/' \
                /etc/nix/nix.conf
        fi
    done
fi
