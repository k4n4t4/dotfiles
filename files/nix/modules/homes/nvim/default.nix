{ inputs, pkgs, lib, config, ... }:
{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      unzip
      nodejs
      python3
      gnumake
      gcc
      luajit
      luarocks
      lua-language-server
      rust-analyzer
      markdownlint-cli
    ];
  };
}
