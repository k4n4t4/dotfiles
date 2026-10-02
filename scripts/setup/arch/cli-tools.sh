# shell
sudo pacman --needed --noconfirm -S fish starship tmux fastfetch

# tools
sudo pacman --needed --noconfirm -S eza bat btop trash-cli zoxide fd ripgrep fzf jq

# neovim
sudo pacman --needed --noconfirm -S lazygit git-delta github-cli tree-sitter-cli neovim luarocks lldb imagemagick nodejs npm

# rust
sudo pacman --needed --noconfirm -S rustup
rustup default stable
rustup component add rust-src
rustup component add rust-analyzer
rustup component add rustfmt
if ! [ -d "$HOME/.cargo/bin" ]; then
    mkdir -p "$HOME/.cargo/bin"
fi
for component in rust-src rust-analyzer rustfmt; do
    ln -sf "$(rustup which "$component")" "$HOME/.cargo/bin/$component"
done
