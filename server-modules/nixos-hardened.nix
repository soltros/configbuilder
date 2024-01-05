{ config, pkgs, ... }:

{
  # Configure the firewall
  networking.firewall = {
    enable = true;
    allowPing = false;
    trustedInterfaces = [ "lo" ]; # Loopback interface
    allowedTCPPorts = [ 22 ]; # SSH port, adjust as needed
  };

  # Enable other security features
  security = {
    hideProcessInformation = true;
    hardened = {
      cpHidePointer = true;
      malloc = "scudo";
    };
  };
}
