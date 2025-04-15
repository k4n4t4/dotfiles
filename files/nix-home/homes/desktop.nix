{ config, pkgs, ... }:
{
  home = {
    stateVersion = "24.05";

    username = "kanata";
    homeDirectory = "/home/kanata";

    packages = with pkgs; [
      fish
      starship
      neovim
      luajit
      luarocks
      eza
      fd
      ripgrep
      fzf
      zoxide
      delta
      trash-cli
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
