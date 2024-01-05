{ config, lib, ... }:

{
  # ...

  fileSystems."/mnt/merged" = {
    device = "/mnt/storage-2:/mnt/storage";  # Combine the paths into a single string
    fsType = "mergerfs";
    options = [
      "defaults"
      "allow_other"
      "use_ino"
      "category.create=mfs"
      "moveonenospc=true"
    ];
  };

  # ...
}
