{ pkgs, ... }:
{
  imports = [
    ../../modules/home/clitools
    ../../modules/home/nvim
    ../../modules/home/ags
    ../../modules/home/fcitx5
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      kitty

      firefox
      thunderbird
      obsidian
      discord
      gimp

      nerd-fonts.comic-shanns-mono
      nerd-fonts.hurmit
    ];
  };
}
