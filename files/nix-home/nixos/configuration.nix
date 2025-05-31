{ config, lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
  };

  security = {
    sudo = {
      wheelNeedsPassword = true;
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Tokyo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
    inputMethod = {
      type = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
      ];
    };
  };

  services.xserver.xkb = {
    layout = "jp";
    variant = "";
  };

  users = {
    users = {
      kanata = {
        description = "kanata";
        home = "/home/kanata";
        group = "kanata";
        extraGroups = [
          "wheel"
          "networkmanager"
        ];
        isNormalUser = true;
        packages = with pkgs; [
        ];
        shell = pkgs.bash;
      };
    };
    groups = {
      kanata = {};
    };
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [
      git
      vim

      hyprlock
      hyprutils
      hypridle
      hyprwayland-scanner
      hyprshot
      uwsm
      kitty
      fish
      starship
      firefox
      feh
      st
      wofi
      swww
      wl-clipboard
      cliphist
      wlogout
    ];
  };

  system.stateVersion = "24.11";
}
