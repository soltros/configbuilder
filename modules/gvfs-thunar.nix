{ config, pkgs, ... }:

{
  options = {
    services.thunar-smb.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable SMB support for Thunar.";
    };
  };

  config = mkIf config.services.thunar-smb.enable {
    environment.systemPackages = with pkgs; [
      thunar
      gvfs
      gvfs-smb
    ];

    services = {
      dbus.enable = true;
      gvfs.enable = true;
    };
  };
}
