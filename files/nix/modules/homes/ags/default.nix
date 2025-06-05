{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    nodejs
    nodePackages.npm
  ];

  programs.ags = {
    enable = true;
    extraPackages = let
      agsPkgs = inputs.ags.packages.${pkgs.system};
    in with pkgs; [
      agsPkgs.apps
      agsPkgs.auth
      agsPkgs.battery
      agsPkgs.bluetooth
      agsPkgs.cava
      agsPkgs.greet
      agsPkgs.hyprland
      agsPkgs.mpris
      agsPkgs.network
      agsPkgs.notifd
      agsPkgs.powerprofiles
      agsPkgs.river
      agsPkgs.tray
      agsPkgs.wireplumber
    ];
  };
}
