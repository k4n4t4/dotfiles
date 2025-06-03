{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ../../modules/homes/clitools
    ../../modules/homes/nvim
    ../../modules/homes/ags
    ../../modules/homes/fcitx5
  ];

  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      uwsm
      hyprlock hyprutils hypridle hyprwayland-scanner hyprshot
      feh st wofi swww wl-clipboard cliphist wlogout
      alsa-utils brightnessctl
      adwaita-icon-theme
      kitty
      firefox
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
