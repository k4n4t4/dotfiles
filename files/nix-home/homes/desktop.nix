{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      fish starship
      neovim luajit luarocks
      eza fd ripgrep fzf zoxide
      delta
      trash-cli
      kitty
      dash
      tmux
    ];
  };
}
