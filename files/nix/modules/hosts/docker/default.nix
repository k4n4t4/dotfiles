{ inputs, pkgs, lib, config, users, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  environment.systemPackages = with pkgs; [
    docker-buildx 
  ];

  users.users = lib.mapAttrs (name: value: {
    extraGroups = [ "docker" ];
  }) users;
}
