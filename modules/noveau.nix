{ config, pkgs, ... }: {

  # Ensure the Nouveau module is loaded
  boot.kernelModules = [ "nouveau" ];

  # Blacklist the proprietary NVIDIA driver, if needed
  boot.blacklistedKernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset" ];

  # Configure Xorg to use the Nouveau driver
  services.xserver = {
    enable = true;
    videoDrivers = [ "nouveau" ];

    # Optional: Configure display settings, if necessary
    # displayManager = {
    #   ...
    # };
    # desktopManager = {
    #   ...
    # };
  };

  # Enable hardware acceleration for Nouveau
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      # Add packages needed for Nouveau acceleration here
      # For example, Mesa for OpenGL:
      mesa
      mesa.drivers
    ];
  };

  # Additional configurations if required
  # For example, to manage power settings for Nouveau:
  # environment.etc."modprobe.d/nouveau.conf".text = ''
  #   options nouveau modeset=1
  # '';
}
