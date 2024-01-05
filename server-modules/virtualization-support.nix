{ config, pkgs, ... }:

{
  # VirtualBox support
  virtualisation.virtualbox.host.enable = true;
  boot.kernelParams = [ "vboxdrv.load_state=1" ];
  boot.kernelModules = [ "vboxdrv" "vboxnetadp" "vboxnetflt" "vboxpci" ];
  users.extraGroups.vboxusers.members = [ "derrik" ];
  
  # Virtualization support
  virtualisation.libvirtd.enable = true;

}

