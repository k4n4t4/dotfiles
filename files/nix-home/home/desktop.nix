{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      kitty
      dash
      zsh
      fish starship
      eza fd ripgrep fzf zoxide btop ncdu delta trash-cli tmux
      lua-language-server
    ];
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nodejs
      python3
      lua-language-server
      markdownlint-cli
      luarocks
      luajit
    ];
  };
}
