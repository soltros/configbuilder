{ config, pkgs, ... }:

{
  # Enable automatic updates
  systemd.timers.nixos-upgrade = {
    enable = true;
    timerConfig.OnCalendar = "weekly";
    wantedBy = [ "timers.target" ];
  };

  systemd.services.nixos-upgrade = {
    script = "${pkgs.nixos-rebuild}/bin/nixos-rebuild switch --upgrade";
    serviceConfig.Type = "oneshot";
  };
}
