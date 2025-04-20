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
      username = "kanata";

      system = "x86_64-linux";
      # system = "aarch64-linux";
      # system = "x86_64-darwin";
      # system = "aarch64-darwin";

      version = "24.11";
    };

    isLinux = config.system == "x86_64-linux" || config.system == "aarch64-linux";
    isDarwin = config.system == "x86_64-darwin" || config.system == "aarch64-darwin";

    home = {
      stateVersion = config.version;
      username = config.username;
      homeDirectory =
        if isLinux then
          "/home/${config.username}"
        else if isDarwin then
          "/Users/${config.username}"
        else
          throw "\"${config.system}\" is unsupported system"
        ;
    };
  in {
    homeConfigurations = {
      "desktop" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${config.system};
        modules = [
          { inherit home; }
          ./homes/common.nix
          ./homes/desktop.nix
        ];
      };
    };
  };
}
