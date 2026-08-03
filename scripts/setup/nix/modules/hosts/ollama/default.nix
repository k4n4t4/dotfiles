{ inputs, pkgs, lib, config, ... }:
{
  environment.systemPackages = [
    pkgs.ollama
  ];

  services.ollama = {
    enable = true;
    loadModels = [ ];
    # acceleration = "cuda";  # NVIDIA
    # acceleration = "rocm";  # AMD
  };
}
