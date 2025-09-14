{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ../../modules/homes/clitools
    ../../modules/homes/nvim
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;
}
