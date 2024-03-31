{ config, pkgs, lib, ... }:

let
  restartServicesScript = pkgs.writeScript "restart-services.sh" ''
    #!/usr/bin/env sh
    ${pkgs.coreutils}/bin/sleep 5
    ${pkgs.systemd}/bin/systemctl restart tailscaled
    ${pkgs.systemd}/bin/systemctl restart NetworkManager
  '';
in
{
  options.services.rebootOnResume = lib.mkEnableOption "Restart tailscaled and NetworkManager services upon resuming from suspend";

  config = lib.mkIf config.services.rebootOnResume.enable {
    systemd.services.rebootOnResume = {
      description = "Restart tailscaled and NetworkManager after resume";
      script = restartServicesScript;
      path = [ pkgs.coreutils pkgs.systemd ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = restartServicesScript;
      };
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
    };

    systemd.targets.resume = {
      wantedBy = [ "suspend.target" "hibernate.target" "hybrid-sleep.target" ];
      before = [ "rebootOnResume.service" ];
    };

    systemd.services."systemd-suspend".wants = [ "rebootOnResume.service" ];
  };
}
