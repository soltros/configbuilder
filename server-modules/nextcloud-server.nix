{ config, pkgs, ... }:

{
  # Environment setup for Nextcloud admin and database passwords
  environment.etc."nextcloud-admin-pass".text = "SECURE_PASSWORD_HERE";
  environment.etc."nextcloud-db-pass".text = "SECURE_PASSWORD_HERE";

  # PostgreSQL service configuration
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_14;  # Adjust the PostgreSQL version as needed
    initialScript = pkgs.writeText "nextcloud-db-init.sql" ''
      CREATE ROLE nextcloud WITH LOGIN PASSWORD 'SECURE_PASSWORD_HERE';
      CREATE DATABASE nextcloud WITH OWNER nextcloud;
    '';
  };

  # PHP-FPM service configuration for Nextcloud
  services.phpfpm.pools.nextcloud = {
    user = "nextcloud";
    group = "nextcloud";
   # listen = "/run/phpfpm/nextcloud.sock"; - Deprecated
    phpOptions = ''
      upload_max_filesize = 1G
      post_max_size = 1G
      memory_limit = 512M
      max_execution_time = 300
      date.timezone = "America/Detroit"
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
    maxUploadSize = "1G"; # Adjust for max upload size
  };

  # Other services and configuration...
}
