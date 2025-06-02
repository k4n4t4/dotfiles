{
  description = "Home Configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    version = "24.11";
    username = "kanata";
    system = "x86_64-linux";

    pkgs = nixpkgs.legacyPackages.${system};

    home = {
      stateVersion = version;
      username = username;
      homeDirectory = "/home/${username}";
    };

    makeHome = { modules ? [] }: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        { inherit home; }
      ] ++ modules;
    };

    makeSystem = { name, modules ? [], homeModules ? [] }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        ./hosts/${name}/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
            };
            users.${username} = {
              inherit home;
              imports = homeModules;
            };
          };
        }
      ] ++ modules;
    };
  in {
    homeConfigurations = {
      "common" = makeHome {
        modules = [
          ./home/common.nix
        ];
      };
      "desktop" = makeHome {
        modules = [
          ./home/common.nix
          ./home/desktop.nix
        ];
      };
    };
    nixosConfigurations = {
      "laptop" = makeSystem {
        name = "laptop";
        modules = [
          ./hosts/modules/hyprland.nix
        ];
        homeModules = [
          ./home/common.nix
          ./home/desktop.nix
        ];
      };
      "desktop" = makeSystem {
        name = "desktop";
        modules = [
          ./hosts/modules/hyprland.nix
        ];
        homeModules = [
          ./home/common.nix
          ./home/desktop.nix
        ];
      };
      "wsl" = makeSystem {
        name = "wsl";
        homeModules = [
          ./home/common.nix
        ];
      };
    };
  };
}
