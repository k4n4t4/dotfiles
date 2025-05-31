{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      uwsm
      hyprlock
      hyprutils
      hypridle
      hyprwayland-scanner
      hyprshot
      kitty
      fish
      zsh
      starship
      firefox
      feh
      st
      wofi
      swww
      wl-clipboard
      cliphist
      wlogout
      amixer
      brightnessctl
    ];
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      nodejs
      python3
      gnumake
      gcc
      luajit
      luarocks
      lua-language-server
      rust-analyzer
      markdownlint-cli
    ];
  };

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
