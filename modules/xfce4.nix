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

  # Enable Pipewire for handling audio and video (revised configuration)
  security.rtkit.enable = true; # Ensures real-time priorities for the Pipewire daemon
  services.pipewire.enable = true;
  services.pipewire.alsa.enable = true; # Allows ALSA clients to use Pipewire
  services.pipewire.pulse.enable = true; # Makes Pipewire act as a drop-in replacement for PulseAudio

  # Optional: Network Manager for network management
  networking.networkmanager.enable = true;
}
