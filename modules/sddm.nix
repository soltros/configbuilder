{ config, pkgs, ... }:

{
#sddm
services.xserver.displayManager.sddm.enable = true;
services.xserver.enable = true;


}
