{ inputs, pkgs, lib, config, ... }:
{
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      dash
      fish
      zsh
      starship
      eza
      fd
      ripgrep
      fzf
      zoxide
      btop
      ncdu
      delta
      trash-cli
      tmux
    ];
  };
}
