{ config, pkgs, ... }:

{
  # Configure the additional Samba shares
  services.samba.extraConfig = ''
    [Storage]
      path = /mnt/merged
      public = yes
      writable = yes
      printable = no
      guest ok = yes
      guest only = yes
      browseable = yes
      create mask = 0660
      directory mask = 0771

    [Speedy NVMe Storage]
      path = /mnt/nvme-storage
      public = yes
      writable = yes
      printable = no
      guest ok = yes
      guest only = yes
      browseable = yes
      create mask = 0660
      directory mask = 0771
  '';
}
