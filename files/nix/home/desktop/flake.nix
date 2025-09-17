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
    astal.url = "github:aylur/astal";
  };

  outputs = inputs: let
    libs = import ../../modules/libs inputs;
  in {
    make = config: libs.makeHome {
      inherit config;
      modules = [
        ../../modules/home/configurations/desktop.nix
        ../../modules/home/clitools
        ../../modules/home/nvim
        ../../modules/home/ags
        ../../modules/home/fcitx5
      ];
    };
  };
}
