{ inputs, pkgs, lib, config, ... }:
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      uwsm
      hyprlock hyprutils hypridle hyprwayland-scanner hyprshot
      feh st wofi swww wl-clipboard cliphist wlogout
      alsa-utils brightnessctl
      adwaita-icon-theme

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
    ];
  };

  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
