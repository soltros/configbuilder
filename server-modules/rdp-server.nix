{ config, pkgs, ... }:

{
  # Enable the Xorg server
  services.xserver = {
    enable = true;
    layout = "us"; # Set your keyboard layout
    displayManager.lightdm.enable = true; # Using LightDM as the display manager
    desktopManager.mate.enable = true; # Enable MATE desktop environment
  };

  # Enable and configure XRDP
  services.xrdp = {
    enable = true;
    # Set the default window manager to start MATE session
    defaultWindowManager = "mate-session";
    openFirewall = true;
  };

  # Open firewall for RDP
  networking.firewall.allowedTCPPorts = [ 3389 ];
}
