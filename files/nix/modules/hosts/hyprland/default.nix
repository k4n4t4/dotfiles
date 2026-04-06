{ inputs, pkgs, lib, config, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.uwsm = {
    enable = true;
    waylandCompositors.hyprland = {
      binPath = "/run/current-system/sw/bin/Hyprland";
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
    };
  };

  environment = {
    systemPackages = with pkgs; [
      hyprlock hyprutils hypridle hyprwayland-scanner hyprshot
      feh st wofi awww wl-clipboard cliphist wlogout
      alsa-utils brightnessctl
      adwaita-icon-theme

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
