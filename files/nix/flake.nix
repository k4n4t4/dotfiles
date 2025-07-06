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

    makeHome = { modules ? [] }: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        {
          home = {
            stateVersion = version;
            username = username;
            homeDirectory = "/home/${username}";
          };
        }
      ] ++ modules;
    };

    makeSystem = { modules ? [], homeModules ? [] }: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
      };
      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            extraSpecialArgs = {
              inherit inputs;
            };
            users.${username} = {
              home = {
                stateVersion = version;
                username = username;
                homeDirectory = "/home/${username}";
              };
              imports = homeModules;
            };
          };
        }
      ] ++ modules;
    };
  in {
    homeConfigurations = {
      "common" = makeHome {
        modules = [ ./homes/common ];
      };
      "desktop" = makeHome {
        modules = [ ./homes/desktop ];
      };
    };
    nixosConfigurations = {
      "laptop" = makeSystem {
        modules = [
          ./hosts/laptop/configuration.nix
          ./modules/hosts/nvidia
          ./modules/hosts/hyprland
        ];
        homeModules = [ ./homes/desktop ];
      };
      "laptop2" = makeSystem {
        modules = [
          ./hosts/laptop2/configuration.nix
          ./modules/hosts/hyprland
        ];
        homeModules = [ ./homes/desktop ];
      };
      "desktop" = makeSystem {
        modules = [
          ./hosts/desktop/configuration.nix
          ./modules/hosts/nvidia
          ./modules/hosts/hyprland
        ];
        homeModules = [ ./homes/desktop ];
      };
      "wsl" = makeSystem {
        modules = [
          ./hosts/wsl/configuration.nix
        ];
        homeModules = [ ./homes/common ];
      };
    };
  };
}
