{ config, pkgs, ... }:
{
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
