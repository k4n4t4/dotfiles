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
  };

  outputs = { self, nixpkgs, home-manager, ... } @ inputs: let
    config = {
      version = "24.11";
      username = "kanata";
      hostname = "nixos";
      system =
        "x86_64-linux"
        # "aarch64-linux"
        # "x86_64-darwin"
        # "aarch64-darwin"
      ;
      # homeDirPrefix = "/home";
      # homeDirSufix = "/kanata";
    };

    isLinux = config.system == "x86_64-linux" || config.system == "aarch64-linux";
    isDarwin = config.system == "x86_64-darwin" || config.system == "aarch64-darwin";

    home = {
      stateVersion = config.version;
      username = config.username;
      homeDirectory =
        if isLinux || isDarwin then
          if config ? homeDirPrefix then
            if config ? homeDirSufix then
              "${config.homeDirPrefix}${config.homeDirSufix}"
            else
              "${config.homeDirPrefix}/${config.username}"
          else
            if isLinux then
              "/home/${config.username}"
            else
              "/Users/${config.username}"
        else
          throw "\"${config.system}\" is unsupported system"
        ;
    };
  in {
    homeConfigurations = {
      "desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${config.system};
        extraSpecialArgs = { inherit inputs; };
        modules = [
          { inherit home; }
          ./home/common.nix
          ./home/desktop.nix
        ];
      };
    };
    nixosConfigurations = {
      ${config.hostname} = nixpkgs.lib.nixosSystem {
        system = config.system;
        specialArgs = { inherit inputs; };
        modules = [
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = { inherit inputs; };
              users.${config.username} = {
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
    };
  };
}
