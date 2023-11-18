{ config, pkgs, ... }:

{
  # Enable the X11 windowing system with Intel drivers
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "intel" ];
  
  # OpenGL configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
}
