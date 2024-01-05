{ config, pkgs, ... }:

{
  # Environment setup for Nextcloud admin and database passwords
  environment.etc."nextcloud-admin-pass".text = "YOUR_NEXTCLOUD_ADMIN_PASSWORD";
  environment.etc."nextcloud-db-pass".text = "YOUR_NEXTCLOUD_DB_PASSWORD";

  # PostgreSQL service configuration
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;  # Adjust the PostgreSQL version as needed
    initialScript = pkgs.writeText "nextcloud-db-init.sql" ''
      CREATE ROLE nextcloud WITH LOGIN PASSWORD 'YOUR_NEXTCLOUD_DB_ROLE_PASSWORD';
      CREATE DATABASE nextcloud WITH OWNER nextcloud;
    '';
  };

  # Nextcloud service configuration
  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud28; # Adjust the Nextcloud version as needed
    hostName = "nixos-server";
    config = {
      dbtype = "pgsql";
      dbname = "nextcloud";
      dbuser = "nextcloud";
      dbpassFile = "/etc/nextcloud-db-pass"; # Reference to the DB password file
      adminpassFile = "/etc/nextcloud-admin-pass";
      # Additional Nextcloud configuration...
    };
   services.nextcloud.maxUploadSize = "1G"; # Adjust for max upload size. Ensure that you've also configured PHP.
  };

  # Other services and configuration...
  
}
