{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ./modules/nvim
    ./modules/ags
    ./modules/fcitx5
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
      adwaita-icon-theme

      alsa-utils
      brightnessctl

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.comic-shanns-mono
      nerd-fonts.hurmit
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "rose-pine-cursor";
      size = 300;
    };
  };
}
