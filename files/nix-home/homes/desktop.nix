{ config, pkgs, ... }:
let
  version = "24.05";
  username = "kanata";
in
{

  fonts.fontconfig.enable = true;

  home = {
    stateVersion = "${version}";

    username = "${username}";
    homeDirectory = "/home/${username}";

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
