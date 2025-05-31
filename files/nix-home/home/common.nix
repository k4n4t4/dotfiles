{ inputs, pkgs, lib, config, ... }:
{
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      git
      vim
    ];
  };
}
