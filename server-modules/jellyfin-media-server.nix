{ config, pkgs, ... }:

{
  # Include Jellyfin packages
  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    xteve
  ];

  # Configure Jellyfin service
  services.jellyfin = {
    enable = true;
    openFirewall = true;

    # Uncomment and set the following options as needed
    # group = "jellyfingroup"; # Group under which Jellyfin runs
    # package = pkgs.jellyfin; # Specific Jellyfin package to use
    # user = "jellyfinuser"; # User account under which Jellyfin runs
  };
}
