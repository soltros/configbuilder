{ config, pkgs, lib, ... }:

{
  # Ensure the Subsonic service is enabled
  services.subsonic = {
    enable = true;  # This line activates Subsonic
    home = "/var/lib/subsonic";  # Specifies the home directory for Subsonic files
    port = 4040;  # HTTP port for Subsonic
    httpsPort = 0;  # Disable HTTPS by default; set to a valid port number to enable
    maxMemory = 100;  # Set the Java maximum heap size
    defaultMusicFolder = "/var/music";  # Set the default music folder
    defaultPodcastFolder = "/var/music/Podcast";  # Set the default podcast folder
    defaultPlaylistFolder = "/var/playlists";  # Set the default playlist folder
    contextPath = "/";  # Set the context path for the URL
    listenAddress = "0.0.0.0";  # Server will listen on all network interfaces
    transcoders = [ "${pkgs.ffmpeg}/bin/ffmpeg" ];  # Include ffmpeg as a transcoder
  };

  # Configure firewall to allow traffic on the Subsonic port
  networking.firewall.allowedTCPPorts = [ 4040 ];  # Add the HTTPS port if used
}
