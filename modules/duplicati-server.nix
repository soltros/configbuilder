{ config, pkgs, ... }: {

  services.duplicati = {
    enable = true;
    package = pkgs.duplicati;
    dataDir = "/home/derrik/.duplicati-backups/";
    user = "derrik";
    port = 8200;
    interface = "127.0.0.1";
  };

}
