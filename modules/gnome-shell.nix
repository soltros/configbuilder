{ config, pkgs, ... }:

{
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.enable = true;

  # Exclude Gnome Programs I don't use.
  environment.gnome.excludePackages = with pkgs.gnome; [
   pkgs.gnome-console  #Gnome Console
   pkgs.gnome.geary    #Gnome Email client
   pkgs.gnome.totem    #Gnome Video player
  ];
  
}

