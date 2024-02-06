{ config, pkgs, lib, ... }:

{
  # Enable the Audiobookshelf service
  services.audiobookshelf = {
    enable = true;
    host = "0.0.0.0"; # Bind to all network interfaces
    port = 8234;
    # Additional Audiobookshelf service configuration can go here
  };

  # Include the audiobookshelf package in the system environment
  environment.systemPackages = with pkgs; [ audiobookshelf ];
}
