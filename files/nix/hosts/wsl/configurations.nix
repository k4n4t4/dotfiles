{ config, lib, pkgs, ... }:
{
  imports = [
    <nixos-wsl/modules>
    ../../modules/hosts/docker
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
}
