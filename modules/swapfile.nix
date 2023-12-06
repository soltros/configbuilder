{ config, pkgs, ... }:

{
  # Enable swap file management
  boot.initrd.swap = {
    # Enable swap file
    enable = true;

    # Define the swap file path and size
    file = {
      path = "/swapfile";
      size = 4096; # Size in MB for a 4GB swap file
    };
  };
}
