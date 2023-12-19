{ config, pkgs, ... }:

{
  # Ensure bindfs is available for filesystem operations
  system.fsPackages = [ pkgs.bindfs ];

  fileSystems =
    let
      mkRoSymBind = path: {
        device = path;
        fsType = "fuse.bindfs";
        options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
      };
      aggregated = pkgs.buildEnv {
        name = "system-icons";
        paths = with pkgs; [
          # Include the Papirus icon theme
          papirus-icon-theme
          # Add any other icon themes or resources as needed
        ];
        pathsToLink = [ "/share/icons" ]; # Link to the icons directory
      };
    in
    {
      "/usr/share/icons" = mkRoSymBind "${aggregated}/share/icons";
    };

  # Flatpak configuration
  services.flatpak = {
    enable = true;
    gtkUsePortal = true; # Ensures GTK applications use the xdg-desktop-portal
  };

  # GNOME configuration (if needed)
  services.xserver.desktopManager.gnome = {
    enable = true;
    # Any additional GNOME-specific configuration
  };
}
