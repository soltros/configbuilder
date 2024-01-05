{ config, pkgs, ... }:

{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # Size in MB for a 4GB swap file
    }
  ];
}
