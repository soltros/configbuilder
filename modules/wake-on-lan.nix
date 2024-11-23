{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.wol;
in {
  options.services.wol = {
    enable = mkEnableOption "Wake-on-LAN support";

    interfaces = mkOption {
      type = types.listOf types.str;
      default = [];
      example = [ "enp0s31f6" "eth0" ];
      description = lib.mdDoc ''
        List of network interfaces to enable Wake-on-LAN on.
        If empty, WoL will be enabled on all available ethernet interfaces.
      '';
    };

    policy = mkOption {
      type = types.listOf (types.enum ["magic" "unicast" "broadcast" "arp" "magicsecure"]);
      default = ["magic"];
      example = ["magic" "unicast"];
      description = lib.mdDoc ''
        WoL policy to use. Common options:
        - magic: Wake on magic packet
        - unicast: Wake on unicast messages
        - broadcast: Wake on broadcast messages
        - arp: Wake on ARP
        - magicsecure: Wake on SecureOn packet
      '';
    };

    keepAliveOnSuspend = mkOption {
      type = types.bool;
      default = true;
      description = lib.mdDoc ''
        Whether to keep the network interface powered during suspend.
      '';
    };
  };

  config = mkIf cfg.enable {
    # Install required packages
    environment.systemPackages = with pkgs; [
      ethtool
      wakeonlan
    ];

    # Enable WoL in the networking stack
    networking.enableWakeonWoL = true;

    # Configure each interface
    networking.interfaces = mkMerge (
      map (interface: {
        ${interface} = {
          wakeOnLan = {
            enable = true;
            inherit (cfg) policy;
          };
        };
      }) (if cfg.interfaces == [] 
          then (attrNames config.networking.interfaces) 
          else cfg.interfaces)
    );

    # Keep interfaces powered during suspend if requested
    powerManagement.powerDownCommands = mkIf cfg.keepAliveOnSuspend (
      concatStringsSep "\n" (
        map (interface: ''
          ${pkgs.ethtool}/bin/ethtool -s ${interface} wol g
        '') (if cfg.interfaces == []
             then (attrNames config.networking.interfaces)
             else cfg.interfaces)
      )
    );

    # Add a systemd service to ensure WoL settings persist across network changes
    systemd.services.wol-configure = {
      description = "Configure Wake-on-LAN settings";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "configure-wol" ''
          ${concatStringsSep "\n" (
            map (interface: ''
              ${pkgs.ethtool}/bin/ethtool -s ${interface} wol g
            '') (if cfg.interfaces == []
                 then (attrNames config.networking.interfaces)
                 else cfg.interfaces)
          )}
        '';
      };
    };
  };
}
