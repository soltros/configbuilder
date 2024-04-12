{ config, pkgs, ... }:
{
  # Enable Jellyfin service
  services.jellyfin.enable = true;

  # Add Jellyfin packages
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    xteve
  ];

  # Advanced configuration example
  services.jellyfin = {
    # Specify the network port Jellyfin should use
    port = 8096;

    # Configure data storage path (modify as needed)
    dataDir = "/var/lib/jellyfin";

    # Enable hardware acceleration (if supported)
    enableHardwareAcceleration = true;

    # Set the user and group under which Jellyfin will run
    user = "jellyfin";
    group = "jellyfin";
  };
}
