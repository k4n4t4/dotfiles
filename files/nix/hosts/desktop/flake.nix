{
  description = "desktop";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:aylur/ags";
  };

  outputs = inputs: let
    libs = import ../../modules/libs inputs;
  in {
    make = config: libs.makeSystem {
      inherit config;
      modules = [
        ../../modules/hosts/configurations/desktop.nix
        ../../modules/hosts/nvidia
        ../../modules/hosts/hyprland
      ];
      homeModules = [
        ../../modules/home/configurations/desktop.nix
        ../../modules/home/clitools
        ../../modules/home/nvim
        ../../modules/home/ags
        ../../modules/home/fcitx5
      ];
    };
  };
}
