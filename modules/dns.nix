{ config, pkgs, lib, ... }:

{
  config = {
    networking.nameservers = [
      "DNS IP ADDRESS HERE"
    ];

    systemd.services.systemd-resolved.enable = lib.mkDefault false;

    environment.etc."resolv.conf".text = ''
      ${lib.concatMapStrings (ns: "nameserver ${ns}\n") config.networking.nameservers}
      options single-request
    '';
  };
}
