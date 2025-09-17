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

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    libs = import ../../modules/libs { inherit nixpkgs home-manager inputs; };
  in {
    make = { username, version }: libs.makeSystem {
      config = { inherit username version; };
      modules = [
        ./configuration.nix
        ../../modules/hosts/intel
        ../../modules/hosts/hyprland
      ];
      homeModules = [ ../../home/desktop ];
    };
  };
}
