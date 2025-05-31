{ inputs, pkgs, lib, config, ... }:
{
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
    ];
  };

  home = {
    packages = with pkgs; [
      uwsm
      hyprlock
      hyprutils
      hypridle
      hyprwayland-scanner
      hyprshot
      kitty
      fish
      zsh
      starship
      firefox
      feh
      st
      wofi
      swww
      wl-clipboard
      cliphist
      wlogout
      adwaita-icon-theme

      alsa-utils
      brightnessctl

      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.comic-shanns-mono
      nerd-fonts.hurmit
    ];

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;
      package = pkgs.rose-pine-cursor;
      name = "rose-pine-cursor";
      size = 300;
    };

    sessionVariables = {
      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
    file.".config/fcitx5/profile".text = ''
      [Groups/0]
      Name=Default
      Default Layout=jp
      DefaultIM=mozc

      [Groups/0/Items/0]
      Name=keyboard-jp
      Layout=

      [Groups/0/Items/1]
      Name=mozc
      Layout=

      [GroupOrder]
      0=Default
    '';
    file.".config/fcitx5/conf/classicui.conf".text = ''
      Vertical Candidate List=False
      WheelForPaging=True
      Font="Sans 10"
      MenuFont="Sans 10"
      TrayFont="Sans Bold 10"
      TrayOutlineColor=#000000
      TrayTextColor=#ffffff
      PreferTextIcon=False
      ShowLayoutNameInIcon=True
      UseInputMethodLanguageToDisplayText=True
      Theme=default-dark
      DarkTheme=default-dark
      UseDarkTheme=False
      UseAccentColor=True
      PerScreenDPI=False
      ForceWaylandDPI=0
      EnableFractionalScale=True
    '';
  };

  programs.neovim = {
    enable = true;
    extraPackages = with pkgs; [
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

  programs.ags = {
    enable = true;
    extraPackages = let
      agsPkgs = inputs.ags.packages.${pkgs.system};
    in with pkgs; [
      agsPkgs.apps
      agsPkgs.auth
      agsPkgs.battery
      agsPkgs.bluetooth
      agsPkgs.cava
      agsPkgs.greet
      agsPkgs.hyprland
      agsPkgs.mpris
      agsPkgs.network
      agsPkgs.notifd
      agsPkgs.powerprofiles
      agsPkgs.river
      agsPkgs.tray
      agsPkgs.wireplumber
    ];
  };
}
