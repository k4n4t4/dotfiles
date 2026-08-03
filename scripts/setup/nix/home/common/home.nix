{ pkgs, ... }:
{
  imports = [
    ../../modules/home/clitools
    ../../modules/home/nvim
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
