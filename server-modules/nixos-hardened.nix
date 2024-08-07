{ config, pkgs, ... }:

{
  # Configure the firewall
  networking.firewall = {
    enable = true;
    allowPing = false;
    trustedInterfaces = [ "lo" ]; # Loopback interface only
    allowedTCPPorts = [
      22  # SSH port
      32400  # Plex web interface
      80  # Nextcloud web interface (HTTP)
      443  # Nextcloud web interface (HTTPS)
      8096  # Emby web interface
    ];
    allowedUDPPorts = [
      1900  # Plex discovery
      5353  # Plex network discovery
      7359  # Emby discovery
    ];
  };
}
