inputs: let
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
  lib = nixpkgs.lib;

  makeHomeDirPath = { username }:
    if builtins.match ".*-darwin" builtins.currentSystem != null then
      if username == "root" then
        "/var/root"
      else
        "/Users/${username}"
    else
      if username == "root" then
        "/root"
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
        };
      };
      groups = {
        ${usergroup} = {};
      };
    };
  };

  makeHomeManagerSettings = { version, username ? builtins.getEnv "USER", settings ? {} }: lib.recursiveUpdate {
    stateVersion = version;
    username = username;
    homeDirectory = makeHomeDirPath { inherit username; };
  } settings;
in {
  inherit makeUser makeHomeDirPath makeHomeManagerSettings;

  makeHome = { version, modules ? [], settings ? {} }: let
    username = builtins.getEnv "USER";
  in home-manager.lib.homeManagerConfiguration ( lib.recursiveUpdate {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      {
        home = makeHomeManagerSettings { inherit version username; };
      }
    ] ++ modules;
  } settings );

  makeSystem = { version, users, modules ? [], homeModules ? [], settings ? {} }: let
  in nixpkgs.lib.nixosSystem ( lib.recursiveUpdate {
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
          users = lib.mapAttrs (name: value: let
            modules = if value ? "modules" then
              value.modules
            else [];
          in {
            home = makeHomeManagerSettings {
              username = name;
              version = version;
            };
            imports = modules ++ homeModules;
          }) users;
        };
        system.stateVersion = version;
      }
    ] ++ lib.mapAttrsToList (name: value: makeUser { username = name; } ) users ++ modules;
  } settings );
}
