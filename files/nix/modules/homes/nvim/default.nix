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
      python3
      gnumake
      gcc
      fd
      ripgrep
      fzf
      nodePackages.npm
      luajitPackages.luarocks
      lua51Packages.lua
      lua-language-server
      rust-analyzer
      cargo
      markdownlint-cli
      libxml2
      imagemagick
    ];
  };
}
