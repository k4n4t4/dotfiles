{ config, pkgs, ... }:
{
  home = {
    stateVersion = "24.05";

    username = "kanata";
    homeDirectory = "/Users/kanata";

    packages = with pkgs; [
      neovim
    ];
  };

  programs = {
    home-manager.enable = true;
  };
}
