{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

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
      alsa-utils
      brightnessctl

      nerd-fonts.comic-shanns-mono
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
