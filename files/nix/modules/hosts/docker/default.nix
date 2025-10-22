{ inputs, pkgs, lib, config, users, ... }:
{
  virtualisation.docker = {
    enable = true;
  };

  users.users = lib.mapAttrs (name: value: {
    extraGroups = [ "docker" ];
  }) users;
}
