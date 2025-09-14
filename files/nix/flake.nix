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

    system = builtins.currentSystem;
    homeDirectory =
      if builtins.match ".*-darwin" system != null then
        "/Users/${username}"
      else
        "/home/${username}"
      ;

    pkgs = nixpkgs.legacyPackages.${system};

    makeUser = { username, usergroup ? username }: {
      users = {
        users = {
          ${username} = {
            description = username;
            home = homeDirectory;
            group = usergroup;
            extraGroups = [
              "wheel"
              "networkmanager"
            ];
            isNormalUser = true;
            shell = pkgs.bash;
          };
        };
        groups = {
          ${usergroup} = {};
        };
      };
    };

    makeHomeManagerSettings = { version, username }: {
      stateVersion = version;
      username = username;
      homeDirectory = homeDirectory;
    };

    makeHome = { modules ? [] }: home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {
        inherit inputs;
      };
      modules = [
        {
          home = makeHomeManagerSettings { inherit version username; };
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
              home = makeHomeManagerSettings { inherit version username; };
              imports = homeModules;
            };
          };
        }
        (makeUser { inherit username; })
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
          ./hosts/desktop/configuration.nix
          ./modules/hosts/intel
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
