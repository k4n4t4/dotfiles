{ inputs, pkgs, lib, config, ... }:
{
  home = {
    packages = with pkgs; [
      dash fish nushell zsh
      starship eza fd ripgrep fzf delta
      btop ncdu tmux gh
      zoxide trash-cli
    ];
  };
}
