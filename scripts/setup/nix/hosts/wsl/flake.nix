{
  description = "Host wsl";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: let
    pkgs = inputs.nixpkgs.legacyPackages.${builtins.currentSystem};
    libs = import ../../modules/libs inputs;
  in libs.makeSystem {
    version = "24.11";
    users = {
      "kanata" = {
        shell = pkgs.fish;
      };
    };
    modules = [
      ./configurations.nix
      {
        wsl.defaultUser = "kanata";
        programs.fish.enable = true;
      }
    ];
    homeModules = [
      ../../home/common/home.nix
    ];
  };
}
