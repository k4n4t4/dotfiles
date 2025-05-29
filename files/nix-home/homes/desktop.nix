{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;

  home = {
    packages = with pkgs; [
      kitty
      dash
      zsh
      fish starship
      neovim luajit luarocks lua-language-server
      eza fd ripgrep fzf zoxide btop ncdu delta trash-cli tmux
    ];
  };
}
