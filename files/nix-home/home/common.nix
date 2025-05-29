{ config, pkgs, ... }:
{
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      git
      vim
    ];
  };
}
