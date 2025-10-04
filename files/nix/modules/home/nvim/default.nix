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
      python3
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
      rust-analyzer
      cargo
      markdownlint-cli
      libxml2
      imagemagick
      emmet-language-server
    ];
  };
}
