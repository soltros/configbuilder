{ config, pkgs, lib, ... }:

{
  options.services.subsonic = {
    enable = lib.mkEnableOption "Subsonic media server";
    home = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/subsonic";
      description = "The directory where Subsonic will create files.";
    };
    port = lib.mkOption {
      type = lib.types.ints.u16;
      default = 4040;
      description = "The port on which Subsonic will listen for incoming HTTP traffic.";
    };
    httpsPort = lib.mkOption {
      type = lib.types.ints.u16;
      default = 0;
      description = "The port on which Subsonic will listen for incoming HTTPS traffic.";
    };
    maxMemory = lib.mkOption {
      type = lib.types.int;
      default = 100;
      description = "The memory limit (max Java heap size) in megabytes.";
    };
    defaultMusicFolder = lib.mkOption {
      type = lib.types.path;
      default = "/var/music";
      description = "Configure Subsonic to use this folder for music.";
    };
    defaultPodcastFolder = lib.mkOption {
      type = lib.types.path;
      default = "/var/music/Podcast";
      description = "Configure Subsonic to use this folder for Podcasts.";
    };
    defaultPlaylistFolder = lib.mkOption {
      type = lib.types.path;
      default = "/var/playlists";
      description = "Configure Subsonic to use this folder for playlists.";
    };
    contextPath = lib.mkOption {
      type = lib.types.str;
      default = "/";
      description = "The context path, i.e., the last part of the Subsonic URL.";
    };
    listenAddress = lib.mkOption {
      type = lib.types.str;
      default = "0.0.0.0";
      description = "The host name or IP address on which to bind Subsonic.";
    };
    transcoders = lib.mkOption {
      type = lib.types.listOf lib.types.path;
      default = [ "${pkgs.ffmpeg}/bin/ffmpeg" ];
      description = "List of paths to transcoder executables that should be accessible from Subsonic.";
    };
  };

  config = lib.mkIf config.services.subsonic.enable {
    users.users.subsonic = {
      isSystemUser = true;
      home = config.services.subsonic.home;
      createHome = true;
    };

    networking.firewall.allowedTCPPorts = [ config.services.subsonic.port ];
    environment.systemPackages = [ pkgs.subsonic ];

    systemd.services.subsonic = {
      description = "Subsonic Media Server";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "subsonic";
        ExecStart = let
          opts = [
            "--port=${toString config.services.subsonic.port}"
            "--https-port=${toString config.services.subsonic.httpsPort}"
            "--max-memory=${toString config.services.subsonic.maxMemory}"
            "--default-music-folder=${config.services.subsonic.defaultMusicFolder}"
            "--default-podcast-folder=${config.services.subsonic.defaultPodcastFolder}"
            "--default-playlist-folder=${config.services.subsonic.defaultPlaylistFolder}"
            "--context-path=${config.services.subsonic.contextPath}"
            "--listen-address=${config.services.subsonic.listenAddress}"
          ];
        in "${pkgs.subsonic}/bin/subsonic ${lib.concatStringsSep " " opts}";
        Restart = "always";
      };

      # Create symlinks for transcoders
      preStart = ''
        mkdir -p ${config.services.subsonic.home}/transcoders
        ${lib.concatMapStrings (transcoder => ''
          ln -sf ${transcoder} ${config.services.subsonic.home}/transcoders/
        '') config.services.subsonic.transcoders}
      '';
    };
  };
}
