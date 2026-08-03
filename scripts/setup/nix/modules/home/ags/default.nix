{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    extraPackages = let
        agsPkgs = inputs.ags.packages.${pkgs.stdenv.hostPlatform.system};
    in with pkgs; [
      nodejs
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
