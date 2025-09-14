{ inputs, pkgs, lib, config, ... }:
{
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      vaapiIntel
      intel-media-driver
    ];
  };
}
