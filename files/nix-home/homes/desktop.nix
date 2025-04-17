{ config, pkgs, ... }:
{

  fonts.fontconfig.enable = true;

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

      kitty
    ];


    file = {};

    sessionVariables = {
      EDITOR = "vim";
    };

  };

  programs = {
    home-manager.enable = true;
  };
}
