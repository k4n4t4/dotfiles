{ inputs, pkgs, lib, config, ... }:
{
  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
      git
      wget
      tree-sitter
      curl
      unzip
      nodejs
      nodePackages.npm
      gnumake
      gcc
      fd
      ripgrep
      fzf
      luajitPackages.luarocks
      lua51Packages.lua
      lua-language-server
      markdownlint-cli
      libxml2
      python3
    ];
  };
}
