{ config, pkgs, ... }:
{
  home = {
    stateVersion = "24.05";

    username = "kanata";
    homeDirectory = "/home/kanata";

    packages = with pkgs; [
      fish
      starship
      neovim
      luajit
      luarocks
      eza
      fd
      ripgrep
      fzf
      zoxide
      delta
      trash-cli

      kitty
      # (
      #   nerdfonts.override {
      #     fonts = [];
      #   }
      # )

    ];
  };

  # file = {};
  #
  # sessionVariables = {
  #   EDITOR = "vim";
  # };

  programs = {
    home-manager.enable = true;
  };
}
