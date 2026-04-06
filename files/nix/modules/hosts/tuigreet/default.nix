{ inputs, pkgs, lib, config, ... }:
{
  services = {
    upower = {
      enable = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet -r --sessions /run/current-system/sw/share/wayland-sessions";
      };
    };
  };
}
