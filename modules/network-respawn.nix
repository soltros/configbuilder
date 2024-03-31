{ config, pkgs, lib, ... }:

{
  options.services.rebootOnResume = {
    enable = lib.mkEnableOption "whether to restart tailscaled and NetworkManager on system resume";
  };

  config = lib.mkIf config.services.rebootOnResume.enable {
    systemd.services.rebootOnResume = {
      description = "Restart tailscaled and NetworkManager after resume";
      after = [ "network-online.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = pkgs.writeShellScript "restart-network-services" ''
          ${pkgs.coreutils}/bin/sleep 5
          ${pkgs.systemd}/bin/systemctl restart tailscaled
          ${pkgs.systemd}/bin/systemctl restart NetworkManager
        '';
      };
    };

    systemd.targets.resume = {
      wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      before = [ "rebootOnResume.service" ];
    };

    systemd.services."systemd-suspend".wants = [ "rebootOnResume.service" ];
  };
}
