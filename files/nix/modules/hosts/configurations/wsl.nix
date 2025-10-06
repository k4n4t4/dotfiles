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

  environment = {
    systemPackages = with pkgs; [
      powershell
      git
      vim
    ];
  };

  system.stateVersion = "24.11";
}
