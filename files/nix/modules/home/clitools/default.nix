{ inputs, pkgs, lib, config, ... }:
{
  home = {
    packages = with pkgs; [
      dash
      fish
      nushell
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
      nodejs
      nodePackages.npm
      gh
    ];
  };
}
