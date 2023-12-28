{ config, pkgs, ... }:

{
services.xserver.displayManager.lightdm.enable = true;
services.xserver.desktopManager.enlightenment.enable = true;
services.acpid.enable = true;
services.xserver.libinput.enable = true;

}
