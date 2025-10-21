{
  description = "Home desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ags.url = "github:aylur/ags";
    astal.url = "github:aylur/astal";
  };

  outputs = inputs: let
    libs = import ../../modules/libs inputs;
  in libs.makeHome {
    version = "24.11";
    modules = [
      ./home.nix
    ];
  };
}
