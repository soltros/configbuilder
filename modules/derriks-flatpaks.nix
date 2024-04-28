{ config, pkgs, ... }:

{
  system.activationScripts.flatpak-setup = {
    text = ''
      # Add the Flathub repository, if it's not already added
      ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

      # Install or update specific flatpak applications
      ${pkgs.flatpak}/bin/flatpak install -y flathub \
        io.kopia.KopiaUI \
        com.valvesoftware.Steam \
        net.davidotek.pupgui2 \
        com.heroicgameslauncher.hgl \
        com.usebottles.bottles \
        io.github.prateekmedia.appimagepool
    '';
    phasen = "setup";
  };
}
