{ config, pkgs, lib, ... }:

{
  # VNC server configuration
  services.tigervnc = {
    enable = true;
    displayNumber = 1;
    depth = 24;
    geometry = "1024x768";
    localHost = true;
    user = "derrik";
    passwordFile = "/path/to/passwd";
    
    # Custom xstartup script to start the MATE desktop
    xstartup = ''
      #!/bin/sh
      # Load X resources (if any)
      if [ -r $HOME/.Xresources ]; then
         xrdb $HOME/.Xresources
      fi
      # Start MATE
      mate-session &
    '';
  };

  # Enable the MATE desktop environment
  services.xserver = {
    enable = true;
    desktopManager.mate.enable = true;
  };

  # Open firewall for VNC
  networking.firewall.allowedTCPPorts = [ 5901 ];
}
