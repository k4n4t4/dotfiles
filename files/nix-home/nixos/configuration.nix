{ config, lib, pkgs, ... }:
{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  environment = {
    systemPackages = with pkgs; [
      git
      vim
    ];
  };

  security = {
    sudo = {
      wheelNeedsPassword = true;
    };
  };

  users = {

    users = {
      kanata = {
        description = "kanata";
        home = "/home/kanata";
        group = "kanata";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        isNormalUser = true;
        packages = with pkgs; [
        ];
        shell = pkgs.bash;
      };
    };

    groups = {
      kanata = {};
    };

  };

  system.stateVersion = "24.11";
}
