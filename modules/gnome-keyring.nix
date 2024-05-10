{ config, pkgs, ... }:

{
 
 #Gnome Keyring
 services.gnome3.gnome-keyring.enable = true;
 security.pam.services.sddm.enableGnomeKeyring = true;

}

