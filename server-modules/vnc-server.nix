{ config, pkgs, lib, ... }:

let
  vncStartupScript = pkgs.writeScript "vnc-startup" ''
    #!/usr/bin/env bash
    # Load X resources, if any
    if [ -r $HOME/.Xresources ]; then
      xrdb $HOME/.Xresources
    fi
    # Start MATE desktop session
    exec mate-session
  '';
in
{
  # Enable the Xorg server
  services.xserver = {
    enable = true;
    layout = "us"; # Set your keyboard layout
    desktopManager.mate.enable = true; # Enable MATE desktop environment
  };

  # Include TigerVNC server package
  environment.systemPackages = with pkgs; [
    tigervnc
  ];

  # Custom systemd service for TigerVNC
  systemd.services.tigervnc = {
    description = "TigerVNC Server";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "forking";
      User = "yourUsername"; # Replace with your username
      ExecStart = "${pkgs.tigervnc}/bin/vncserver -localhost no -depth 24 -geometry 1024x768 :1 -xstartup ${vncStartupScript}";
      ExecStop = "${pkgs.tigervnc}/bin/vncserver -kill :1";
    };
  };

  # Open firewall for VNC
  networking.firewall.allowedTCPPorts = [ 5901 ]; # Adjust the port number as needed
}
