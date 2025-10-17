inputs: let
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};

  makeHomeDirPath = { username }:
    if builtins.match ".*-darwin" builtins.currentSystem != null then
      "/Users/${username}"
    else
      "/home/${username}"
    ;

  makeUser = { username, usergroup ? username }: {
    users = {
      users = {
        ${username} = {
          description = username;
          home = makeHomeDirPath { inherit username; };
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
    homeDirectory = makeHomeDirPath { inherit username; };
  };
in {
  makeHome = { config, modules ? [] }: let
    username = config.username;
    version = config.version;
  in home-manager.lib.homeManagerConfiguration {
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

  makeSystem = { config, modules ? [], homeModules ? [] }: let 
    username = config.username;
    version = config.version;
  in nixpkgs.lib.nixosSystem {
    system = builtins.currentSystem;
    specialArgs = {
      inherit inputs;
    };
    modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = false;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs;
          };
          users.${username} = {
            home = makeHomeManagerSettings { inherit version username; };
            imports = homeModules;
          };
        };
        system.stateVersion = version;
      }
      (makeUser { inherit username; })
    ] ++ modules;
  };
}
