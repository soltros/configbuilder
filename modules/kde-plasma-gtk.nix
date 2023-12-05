{ config, pkgs, ... }:

{
  # Ensure the environment is set up for GTK applications
  environment.systemPackages = with pkgs; [
    gnome3.gnome-themes-extra # Breeze themes are included here
  ];

  # Set the global GTK theme to Breeze Dark
  environment.variables.GTK_THEME = "Breeze-Dark";

  # Alternatively, you can use the `gtk3` package's configuration
  # Uncomment the following lines if you prefer this method
  # services.xserver.desktopManager.gnome3.enable = true;
  # services.xserver.desktopManager.gnome3.extraGSettingsOverrides = ''
  #   [org.gnome.desktop.interface]
  #   gtk-theme='Breeze-Dark'
  # '';
}
