{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      git
      vim
      gnumake
      gcc
      python3
      nodejs
    ];
  };
}
