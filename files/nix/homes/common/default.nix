{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ../../modules/homes/clitools
    ../../modules/homes/nvim
  ];

  programs.home-manager.enable = true;
}
