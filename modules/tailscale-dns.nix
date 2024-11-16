{ config, pkgs, lib, ... }:

{
  config = {
    networking.nameservers = [
      "100.85.114.72"                # IPv4 DNS server
      "fd7a:115c:a1e0::f101:7248"    # IPv6 DNS server
    ];

    systemd.services.systemd-resolved.enable = lib.mkDefault false;

    environment.etc."resolv.conf".text = ''
      ${lib.concatMapStrings (ns: "nameserver ${ns}\n") config.networking.nameservers}
      options single-request
    '';
  };
}
