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

  outputs = inputs: let
    libs = import ../../modules/libs inputs;
  in {
    make = config: libs.makeSystem {
      inherit config;
      modules = [
        ../../modules/configurations/hosts/wsl.nix
        {
          wsl.defaultUser = config.username;
        }
      ];
      homeModules = [ ../../modules/configurations/home/common.nix ];
    };
  };
}
