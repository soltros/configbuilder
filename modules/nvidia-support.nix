{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];

  # OpenGL configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Nvidia configuration
  hardware.nvidia.nvidiaSettings = true;

  # Modesetting
  hardware.nvidia.modesetting.enable = true;
}

