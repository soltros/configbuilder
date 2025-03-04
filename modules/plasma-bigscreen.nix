{ config, lib, pkgs, ... }:

with lib;

let
  sessionType = config.services.bigscreen-session.sessionType;
  plasmaBigscreenExec = if sessionType == "wayland" then "plasma-bigscreen-wayland" else "plasma-bigscreen-x11";

  plasmaBigscreenSession = pkgs.writeTextDir "share/xsessions/plasma-bigscreen.desktop" ''
    [Desktop Entry]
    Type=XSession
    Exec=${pkgs.plasma-bigscreen}/bin/${plasmaBigscreenExec}
    TryExec=${pkgs.plasma-bigscreen}/bin/${plasmaBigscreenExec}
    DesktopNames=KDE
    Name=Plasma Bigscreen (${sessionType})
    Comment=KDE Plasma Bigscreen ${if sessionType == "wayland" then "Wayland" else "X11"} Session
  '';

in {
  options = {
    services.bigscreen-session.enable = mkEnableOption "Plasma Bigscreen session";
    services.bigscreen-session.sessionType = mkOption {
      type = types.enum [ "x11" "wayland" ];
      default = "x11";
      description = "Choose between X11 or Wayland session for Plasma Bigscreen.";
    };
  };

  config = mkIf config.services.bigscreen-session.enable {
    services.xserver.displayManager.sessionPackages = [ plasmaBigscreenSession ];
    services.xserver.displayManager.defaultSession = "plasma-bigscreen";
    environment.systemPackages = [ pkgs.libsForQt5.plasma-bigscreen ];
  };
}
