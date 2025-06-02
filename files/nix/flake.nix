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

    home = {
      stateVersion = version;
      username = username;
      homeDirectory = "/home/${username}";
    };
  in {
    homeConfigurations = {
      "common" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
        modules = [
          { inherit home; }
          ./home/common.nix
        ];
      };
      "desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = { inherit inputs; };
        modules = [
          { inherit home; }
          ./home/common.nix
          ./home/desktop.nix
        ];
      };
    };
    nixosConfigurations = {
      "laptop" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          {
            services = {
              upower = {
                enable = true;
              };
              greetd = {
                enable = true;
                settings.default_session = {
                  command = "${nixpkgs.legacyPackages.${system}.greetd.tuigreet}/bin/tuigreet -r --cmd Hyprland";
                };
              };
            };

            programs.hyprland = {
              enable = true;
              xwayland.enable = true;
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.${username} = {
                inherit home;
                imports = [
                  ./home/common.nix
                  ./home/desktop.nix
                ];
              };
            };
          }
        ];
      };
      "desktop" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/laptop/configuration.nix
          {
            services = {
              upower = {
                enable = true;
              };
              greetd = {
                enable = true;
                settings.default_session = {
                  command = "${nixpkgs.legacyPackages.${system}.greetd.tuigreet}/bin/tuigreet -r --cmd Hyprland";
                };
              };
            };

            programs.hyprland = {
              enable = true;
              xwayland.enable = true;
            };
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.${username} = {
                inherit home;
                imports = [
                  ./home/common.nix
                  ./home/desktop.nix
                ];
              };
            };
          }
        ];
      };
      "wsl" = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/wsl/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.${username} = {
                inherit home;
                imports = [
                  ./home/common.nix
                  ./home/modules/nvim
                ];
              };
            };
          }
        ];
      };
    };
  };
}
