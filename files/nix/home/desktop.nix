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
    extraPackages = with pkgs; [
      inputs.ags.packages.${pkgs.system}.apps
      inputs.ags.packages.${pkgs.system}.auth
      inputs.ags.packages.${pkgs.system}.battery
      inputs.ags.packages.${pkgs.system}.bluetooth
      inputs.ags.packages.${pkgs.system}.cava
      inputs.ags.packages.${pkgs.system}.greet
      inputs.ags.packages.${pkgs.system}.hyprland
      inputs.ags.packages.${pkgs.system}.mpris
      inputs.ags.packages.${pkgs.system}.network
      inputs.ags.packages.${pkgs.system}.notifd
      inputs.ags.packages.${pkgs.system}.powerprofiles
      inputs.ags.packages.${pkgs.system}.river
      inputs.ags.packages.${pkgs.system}.tray
      inputs.ags.packages.${pkgs.system}.wireplumber
    ];
  };
}
