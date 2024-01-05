# storage-mounts.nix

{ lib, ... }:

{
  fileSystems."/mnt/storage/disk1" = {
    device = "/dev/sdb1";
    fsType = "btrfs";
  };

  fileSystems."/mnt/storage/disk2" = {
    device = "/dev/sdc1";
    fsType = "btrfs";
  };

  fileSystems."/mnt/storage" = {
    device = "/mnt/storage/disk1:/mnt/storage/disk2";
    fsType = "fuse.mergerfs";
    options = [ "defaults" "allow_other" "category.create=mfs" "moveonenospc=true" "minfreespace=5G" ];
  };
}
