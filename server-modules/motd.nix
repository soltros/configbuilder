{ config, pkgs, ... }:

{
  users.motd = writeShellScript "motd.sh" ''
    echo "
    *This is a NixOS server, running on ${config.boot.kernelPackages.kernel.version} 
    *  Uptime: $(uptime -p)
    *  Load average: $(cat /proc/loadavg | awk '{print $1" "$2" "$3}')
    *  Memory usage: $(free -h | awk 'NR==2 {print $3" "$4}')"
  '';
}
