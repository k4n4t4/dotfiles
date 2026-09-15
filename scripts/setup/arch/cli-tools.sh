sudo pacman --needed --noconfirm -S lazygit git-delta github-cli jq fzf fd ripgrep zoxide eza bat tldr navi btop trash-cli wl-clipboard tree-sitter-cli fish tmux starship neovim luarocks lldb imagemagick nodejs npm fastfetch 7zip

sudo pacman --needed --noconfirm -S rustup
rustup default stable
rustup component add rust-src
rustup component add rust-analyzer
rustup component add rustfmt
for component in rust-src rust-analyzer rustfmt; do
    ln -sf "$(rustup which "$component")" "$HOME/.cargo/bin/$component"
done

sudo npm install -g @github/copilot
