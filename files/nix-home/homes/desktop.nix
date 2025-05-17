{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      kitty
      dash
      zsh
      fish starship
      neovim luajit luarocks
      eza fd ripgrep fzf zoxide btop ncdu delta trash-cli tmux
    ];
  };
}
