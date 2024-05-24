{ config, lib, pkgs, ... }:
let
  tftpRoot = "/var/lib/tftpboot";
  netbootxyzUrl = "https://boot.netboot.xyz";
in
{
  options.pxe-server = {
    # ... (previous options)
    netbootxyz = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable netboot.xyz support";
    };
  };

  config = lib.mkIf config.pxe-server.enable {
    # ... (Pixiecore and TFTP configuration)

    # netboot.xyz support
    boot.loader.efi.chainload = lib.mkIf config.pxe-server.netbootxyz
      "${netbootxyzUrl}/ipxe/netboot.xyz.efi";

    boot.loader.grub = lib.mkIf config.pxe-server.netbootxyz {
      enable = true;
      version = 2;
      device = "net";
      efiSupport = true;
      enableCryptodisk = true;
      grubCfg = ''
        menuentry "Netboot.xyz" {
          insmod chain
          chainloader (${netbootxyzUrl}/ipxe/netboot.xyz.efi)
        }
      '';
    };
  };
}
