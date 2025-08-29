{ config, lib, pkgs, ... }:
let
  username = "kanata";
  usergroup = "kanata";
in
{
  users = {
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
        shell = pkgs.bash;
      };
    };
    groups = {
      ${usergroup} = {};
    };
  };
}
