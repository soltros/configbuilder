{ config, pkgs, lib, ... }:

{
  options.services.rebootOnResume = {
    enable = lib.mkEnableOption "whether to restart tailscaled and NetworkManager on system resume";
  };

  config = lib.mkIf config.services.rebootOnResume.enable {
    systemd.services.rebootOnResume = {
      description = "Restart tailscaled and NetworkManager after resume";
      script = ''
        #!/bin/sh
        /run/current-system/sw/bin/sleep 5
        /run/current-system/sw/bin/systemctl restart tailscaled
        /run/current-system/sw/bin/systemctl restart NetworkManager
      '';
      serviceConfig.Type = "oneshot";
      path = [ pkgs.coreutils pkgs.systemd ];
    };

    # Using systemd-sleep to hook into the resume process
    environment.etc."systemd/system-sleep/rebootOnResume.sh".source = pkgs.writeShellScriptBin "rebootOnResume.sh" ''
      #!/bin/sh
      case $1/$2 in
        pre/*)
          # No action needed before sleep
          ;;
        post/*)
          # Actions to perform after waking up from sleep
          systemctl start rebootOnResume.service
          ;;
      esac
    '';
  };
}
