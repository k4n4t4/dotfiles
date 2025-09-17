{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    ../../modules/home/clitools
    ../../modules/home/nvim
    ../../modules/home/ags
    ../../modules/home/fcitx5
  ];

  nixpkgs.config.allowUnfree = true;
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
      thunderbird
      obsidian

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
