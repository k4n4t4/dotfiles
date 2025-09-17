{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ../../modules/home/clitools
    ../../modules/home/nvim
  ];

  programs.home-manager.enable = true;
}
