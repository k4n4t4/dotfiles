{ config, lib, pkgs, ... }:
{
  imports = [
    <nixos-wsl/modules>
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  wsl.enable = true;
  wsl.defaultUser = "kanata";

  users = let
    username = "kanata";
    usergroup = "kanata";
  in {
    users = {
      kanata = {
        description = username;
        home = "/home/${username}";
        group = usergroup;
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
      ${usergroup} = {};
    };
  };

  environment = {
    systemPackages = with pkgs; [
      powershell
      git
      vim
    ];
  };

  system.stateVersion = "24.11";
}
