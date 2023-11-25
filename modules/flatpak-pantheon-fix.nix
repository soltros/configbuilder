{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.pantheonFlatpakCursors;
  mkRoSymBind = path: {
    device = path;
    fsType = "fuse.bindfs";
    options = [ "ro" "resolve-symlinks" "x-gvfs-hide" ];
  };
in
{
  options.services.pantheonFlatpakCursors = {
    enable = mkEnableOption "Enable Pantheon Flatpak Cursors";
    cursorThemePackage = mkOption {
      type = types.package;
      default = pkgs.xcursor-themes; # default cursor package
      description = "The Nix package providing the cursor theme.";
    };
  };

  config = mkIf cfg.enable {
    system.fsPackages = [ pkgs.bindfs ];

    fileSystems."/usr/share/icons" = mkRoSymBind "${cfg.cursorThemePackage}/share/icons";
  };
}
