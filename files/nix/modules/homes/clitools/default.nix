{ inputs, pkgs, lib, config, ... }:
{
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
      nodejs
      gh
    ];
  };
}
