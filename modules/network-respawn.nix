{ config, pkgs, lib, ... }: {

  # Ensure the systemd services are available
  options.services.rebootOnResume = lib.mkOption {
    type = lib.types.bool;
    default = true;
    description = ''
      Whether to reboot tailscaled and NetworkManager services upon resuming from suspend.
    '';
  };

  config = lib.mkIf config.services.rebootOnResume {
    systemd.services.rebootOnResume = {
      description = "Restart tailscaled and NetworkManager after resume";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target", "suspend.target", "hibernate.target", "hybrid-sleep.target" ];

      script = ''
        # Wait for the system to fully resume
        ${pkgs.coreutils}/bin/sleep 5

        # Restart the tailscaled service
        ${pkgs.systemd}/bin/systemctl restart tailscaled

        # Restart the NetworkManager service
        ${pkgs.systemd}/bin/systemctl restart NetworkManager
      '';

      path = [ pkgs.coreutils pkgs.systemd ];
      serviceConfig.Type = "oneshot";
    };

    # Create a systemd target for resume
    systemd.targets.resume = {
      wantedBy = [ "suspend.target", "hibernate.target", "hybrid-sleep.target" ];
      before = [ "rebootOnResume.service" ];
    };

    systemd.services."systemd-suspend".wants = [ "rebootOnResume.service" ];
  };
}
