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
      wezterm
      kitty

      firefox
      thunderbird
      obsidian
      discord
      gimp

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      nerd-fonts.comic-shanns-mono
      nerd-fonts.hurmit
    ];
  };

  fonts.fontconfig.enable = true;
}
