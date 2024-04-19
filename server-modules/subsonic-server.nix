{ config, pkgs, lib, ... }:

{
  # No need to define options if they are already declared in the NixOS module

  config = lib.mkIf config.services.subsonic.enable {
    users.users.subsonic = {
      isSystemUser = true;
      home = config.services.subsonic.home;
      createHome = true;
    };

    # Directly use the settings to configure Subsonic service
    services.subsonic = {
      enable = true;
      home = "/var/lib/subsonic";
      port = 4040;
      httpsPort = 0;  # HTTPS disabled by default, set to another port to enable
      maxMemory = 100;
      defaultMusicFolder = "/var/music";
      defaultPodcastFolder = "/var/music/Podcast";
      defaultPlaylistFolder = "/var/playlists";
      contextPath = "/";
      listenAddress = "0.0.0.0";
      transcoders = [ "${pkgs.ffmpeg}/bin/ffmpeg" ];  # Adjust if other transcoders are needed
    };

    networking.firewall.allowedTCPPorts = [ config.services.subsonic.port ] ++
      lib.optional (config.services.subsonic.httpsPort != 0) config.services.subsonic.httpsPort;

    systemd.services.subsonic.preStart = lib.concatMapStringsSep "\n" (transcoder: ''
      mkdir -p ${config.services.subsonic.home}/transcoders;
      ln -sf ${transcoder} ${config.services.subsonic.home}/transcoders/;
    '') config.services.subsonic.transcoders;
  };
}
