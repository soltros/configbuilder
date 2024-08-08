{ config, pkgs, ... }:

{
  services.motd = {
    enable = true;
    text = ''
      *************************************************************
      *                    Welcome to ${config.networking.hostName}                    *
      *************************************************************
      *  This is a NixOS server, running on ${pkgs.linuxPackages.kernel.version}  *
      *  Uptime: $(uptime -p)
      *  Load average: $(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
      *  Memory usage: $(free -h | awk 'NR==2 {print $3" "$4}')
      *************************************************************
    '';
  };
}
