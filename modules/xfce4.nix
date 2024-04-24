{ config, pkgs, ... }:

{
  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Configure the display manager
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.lightdm.greeters.gtk.enable = true;

  # Enable the XFCE desktop environment
  services.xserver.desktopManager.xfce.enable = true;

  # Set LightDM as the default display manager
  services.xserver.displayManager.defaultSession = "xfce";

  # Enable Pipewire for audio and video support
  security.rtkit.enable = true; # Real-time privileges for Pipewire
  services.pipewire.enable = true;
  services.pipewire.mediaSession.enable = true;
  services.pipewire.alsa.enable = true; # Compatibility with ALSA applications
  services.pipewire.pulse.enable = true; # To replace PulseAudio functionalities

}
