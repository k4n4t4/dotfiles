{ inputs, ... }: let
  pkgs = inputs.nixpkgs.legacyPackages.${system};
in {
  services = {
    upower = {
      enable = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --cmd Hyprland";
      };
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
