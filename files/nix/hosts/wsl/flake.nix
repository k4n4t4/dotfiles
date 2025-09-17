{
  description = "wsl";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    libs = import ../../modules/libs { inherit nixpkgs home-manager inputs; };
  in {
    make = { username, version }: libs.makeSystem {
      config = { inherit username version; };
      modules = [
        ./configuration.nix
      ];
      homeModules = [ ../../home/common ];
    };
  };
}
