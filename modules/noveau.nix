{ config, pkgs, lib, ... }: {

  # Ensure the Nouveau module is loaded and enable early KMS
  boot.kernelModules = [ "nouveau" ];
  boot.initrd.availableKernelModules = [ "nouveau" "drm" "drm_kms_helper" ];
  boot.kernelParams = [ "nouveau.modeset=1" ];

  # Blacklist the proprietary NVIDIA driver, if needed
  boot.blacklistedKernelModules = [ "nvidia" "nvidia_uvm" "nvidia_drm" "nvidia_modeset" ];

  # Ensure that GNOME is set to use Wayland and configure Xorg to use the Nouveau driver as a fallback
  services.xserver = {
    enable = true;
    videoDrivers = [ "nouveau" ];
    displayManager.sessionCommands = lib.mkBefore ''
      # Ensure DRI3 is enabled for Xorg sessions
      mkdir -p /etc/X11/xorg.conf.d/
      cat <<EOF > /etc/X11/xorg.conf.d/20-nouveau.conf
      Section "Device"
          Identifier "Nouveau Card"
          Driver "nouveau"
          Option "DRI" "3"
      EndSection
      EOF
    '';
  };

  # Automatically select the Wayland session for GDM (if using GDM)
  services.xserver.displayManager.gdm.wayland = true;

  # Enable hardware acceleration for Nouveau
  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      mesa
      mesa.drivers
      libdrm # Ensure libdrm is included for better compatibility
    ];
  };

  # Update systemPackages with tools for diagnostics and potential performance improvements
  environment.systemPackages = with pkgs; [
    # Include diagnostic tools (might require manual operation)
    glxinfo # For checking OpenGL renderer and verifying hardware acceleration
    mesa-demos # Additional OpenGL utilities
  ];

  # Additional configurations if required, like power management or performance tuning
  # Consider creating custom scripts or systemd services for runtime performance adjustments

  # Note: Adjusting environment variables or other runtime Wayland-specific optimizations
  # might need to be set in user profiles or through session scripts
}
