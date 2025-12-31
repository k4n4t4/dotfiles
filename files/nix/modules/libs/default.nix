inputs: let
  nixpkgs = inputs.nixpkgs;
  home-manager = inputs.home-manager;
  pkgs = nixpkgs.legacyPackages.${builtins.currentSystem};
  lib = nixpkgs.lib;

  makeHomeDirPath = username:
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
          home = makeHomeDirPath username;
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
in {
  inherit makeUser makeHomeDirPath;

  makeHome = { version, modules ? [], settings ? {} }: let
    username = builtins.getEnv "USER";
  in home-manager.lib.homeManagerConfiguration ( lib.recursiveUpdate {
    inherit pkgs;
    extraSpecialArgs = {
      inherit inputs;
    };
    modules = [
      {
        home = {
          inherit username;
          stateVersion = version;
          homeDirectory = makeHomeDirPath username;
        };
      }
    ] ++ modules;
  } settings );

  makeSystem = { version, users, modules ? [], homeModules ? [], settings ? {} }: let
    specialArgs = {
      inherit inputs users version;
    };
  in nixpkgs.lib.nixosSystem ( lib.recursiveUpdate {
    system = builtins.currentSystem;
    specialArgs = specialArgs;
    modules = [
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = specialArgs;
          users = lib.mapAttrs (name: value: let
            modules = if value ? "modules" then
              value.modules
            else [];
          in {
            home = {
              username = name;
              stateVersion = version;
              homeDirectory = makeHomeDirPath name;
            };
            imports = modules ++ homeModules;
          }) users;
        };
        system.stateVersion = version;
      }
    ] ++ lib.mapAttrsToList (name: value: makeUser { username = name; } ) users ++ modules;
  } settings );
}
