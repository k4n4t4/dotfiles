{ inputs, pkgs, lib, config, ... }:
{
  services = {
    upower = {
      enable = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet -r --cmd Hyprland";
      };
    };
  };
}
