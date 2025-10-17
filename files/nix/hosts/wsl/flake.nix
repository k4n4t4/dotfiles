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
        ../../modules/hosts/configurations/wsl.nix
        {
          wsl.defaultUser = config.username;
        }
      ];
      homeModules = [ ../../home/common ];
    };
  };
}
