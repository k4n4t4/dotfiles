{
  description = "Home";

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
    libs = import ../modules/libs { inherit nixpkgs home-manager inputs; };
  in {
    make = { username, version }: {
      "common" = libs.makeHome {
        config = { inherit username version; };
        modules = [ ./common ];
      };
      "desktop" = libs.makeHome {
        config = { inherit username version; };
        modules = [ ./desktop ];
      };
    };
  };
}
