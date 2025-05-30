{ inputs, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      kitty
      dash
      zsh
      fish starship
      eza fd ripgrep fzf zoxide btop ncdu delta trash-cli tmux
    ];
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nodejs
      python3
      gnumake
      gcc
      luajit
      luarocks
      lua-language-server
      rust-analyzer
      markdownlint-cli
    ];
  };
}
