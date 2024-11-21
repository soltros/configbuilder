{ config, lib, pkgs, ... }:
{
  # Load nvidia driver for Xorg and Wayland
  services.xserver.enable = true;
  services.xserver.videoDrivers = ["nvidia"];

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    # Removed driSupport options as they're no longer needed
  };

  # Configure nvidia hardware
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    powerManagement.enable = false;
    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module
    open = false;

    # Enable the Nvidia settings menu
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Add nvidia-specific packages
  environment.systemPackages = with pkgs; [
    nvidia-docker
  ];

  # Optional: Increase max map count for large AI models
  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
  };
}
