{ config, pkgs, ... }:

{
#sddm
services.displayManager.sddm.enable = true;
services.xserver.enable = true;


}
