{ config, pkgs, ... }:
{
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.xserver.enable = true;

  # Exclude Gnome Programs I don't use.
  environment.gnome.excludePackages = with pkgs; [
    gnome-console       #Gnome Console
    geary               #Gnome Email client
    totem               #Gnome Video player
  ];

  # Add a custom script to your system
  environment.systemPackages = with pkgs; [
    (writeScriptBin "fix-gnome-display" ''
      #!${bash}/bin/bash
      notify-send "Display Fix Initiated" "Session will restart in 5 seconds..." -u critical -t 5000
      
      sleep 5
      
      dbus-send --session --type=method_call \
        --dest=org.gnome.SessionManager \
        /org/gnome/SessionManager \
        org.gnome.SessionManager.Logout \
        uint32:1
    '')
  ];
}
