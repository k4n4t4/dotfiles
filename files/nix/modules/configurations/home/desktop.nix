{ pkgs, ... }:
{
  imports = [
    ../../home/clitools
    ../../home/nvim
    ../../home/ags
    ../../home/fcitx5
  ];

  nixpkgs.config.allowUnfree = true;
  programs.home-manager.enable = true;

  home = {
    packages = with pkgs; [
      uwsm
      hyprlock hyprutils hypridle hyprwayland-scanner hyprshot
      # hyprlandPlugins.hyprscrolling
      feh st wofi swww wl-clipboard cliphist wlogout
      alsa-utils brightnessctl
      adwaita-icon-theme
      kitty

      firefox
      thunderbird
      obsidian

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
  };

# exec-once = /nix/store/wm9npw769j5z8zfap6bgfka0rhd6y85c-dbus-1.14.10/bin/dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
# exec-once=hyprctl plugin load /nix/store/gcl76dgkq301ghkiw4jy367vhw9qvz49-hyprscrolling-0.50.0/lib/libhyprscrolling.so
  # wayland.windowManager.hyprland = {
  #   enable = true;
  #   plugins = with pkgs.hyprlandPlugins; [
  #     hyprscrolling
  #   ];
  # };
}
