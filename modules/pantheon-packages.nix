{ config, pkgs, ... }: 

{
  # Add Pantheon packages to the system environment
  environment.systemPackages = with pkgs; [
    pkgs.pantheon-tweaks
    pantheon.switchboard-plug-about
    pantheon.switchboard-plug-a11y
    pantheon.switchboard-plug-applications
    pantheon.switchboard-plug-bluetooth
    pantheon.switchboard-plug-datetime
    pantheon.switchboard-plug-display
    pantheon.switchboard-plug-keyboard
    pantheon.switchboard-plug-mouse-touchpad
    pantheon.switchboard-plug-network
    pantheon.switchboard-plug-notifications
    pantheon.switchboard-plug-onlineaccounts
    pantheon.switchboard-plug-power
    pantheon.switchboard-plug-printers
    pantheon.switchboard-plug-security-privacy
    pantheon.switchboard-plug-sharing
    pantheon.switchboard-plug-sound
    pantheon.switchboard-plug-wacom
    pantheon.switchboard-plug-pantheon-shell
  ];
}
