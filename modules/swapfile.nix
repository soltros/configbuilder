{ config, pkgs, ... }:

{
  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 4 * 1024; # Size in MB (4 GB)
    }
  ];
}
