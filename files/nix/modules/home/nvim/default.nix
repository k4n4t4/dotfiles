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
      rust-analyzer
      cargo
      markdownlint-cli
      libxml2
      imagemagick
      emmet-language-server
      ast-grep
      ccls
      harper
      sourcekit-lsp

      (python3.withPackages (ps: with ps; [
        pip
        setuptools
      ]))
    ];
  };
}
