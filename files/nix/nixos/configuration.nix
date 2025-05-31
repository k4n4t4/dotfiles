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

  users = let
    username = "kanata";
    usergroup = "kanata";
  in {
    users = {
      kanata = {
        description = "${username}";
        home = "/home/${username}";
        group = "${usergroup}";
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
      "${usergroup}" = {};
    };
  };

  services = {
    upower = {
      enable = true;
    };
    greetd = {
      enable = true;
      settings.default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet -r --cmd Hyprland";
      };
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
    ];
  };

  system.stateVersion = "24.11";
}
