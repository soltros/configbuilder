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

  # PHP-FPM service configuration for Nextcloud
  services.phpfpm.pools = {
    nextcloud = {
      user = config.services.nextcloud.config.user;
      group = config.services.nextcloud.config.group;
      listen = "/run/phpfpm/nextcloud.sock";
      listen.owner = config.services.nextcloud.config.user;
      listen.group = config.services.nextcloud.config.group;
      phpOptions = ''
        upload_max_filesize = 1G
        post_max_size = 1G
        memory_limit = 512M
        max_execution_time = 300
        date.timezone = "UTC"
      '';
    };
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
    # Link the PHP-FPM pool to the Nextcloud service
    phpFpm.pool = "nextcloud";
  };

  # Other services and configuration...
}
