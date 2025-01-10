{ config, lib, pkgs, ... }: {
  services.nginx.enable = false;
  services.nextcloud = {
    enable = true;
    hostName = "localhost";
    datadir = "/mnt/data/nextcloud";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/mnt/data/nextcloud/admin_secret";
    };
    settings = {
      overwritehost = "localhost";
      overwriteport = 8090;
    };
  };
  services.phpfpm.pools.nextcloud.settings = {
    "listen.owner" = config.services.httpd.user;
    "listen.group" = config.services.httpd.group;
  };
  services.httpd = {
    enable = true;
    adminAddr = "webmaster@localhost";
    extraModules = [ "proxy_fcgi" ];
    virtualHosts."localhost" = {
      documentRoot = config.services.nextcloud.package;
      extraConfig = ''
        <Directory "${config.services.nextcloud.package}">
          <FilesMatch "\.php$">
            <If "-f %{REQUEST_FILENAME}">
              SetHandler "proxy:unix:${config.services.phpfpm.pools.nextcloud.socket}|fcgi://localhost/"
            </If>
          </FilesMatch>
          <IfModule mod_rewrite.c>
            RewriteEngine On
            RewriteBase /
            RewriteRule ^index\.php$ - [L]
            RewriteCond %{REQUEST_FILENAME} !-f
            RewriteCond %{REQUEST_FILENAME} !-d
            RewriteRule . /index.php [L]
          </IfModule>
          DirectoryIndex index.php
          Require all granted
          Options +FollowSymLinks
        </Directory>
      '';
    };
  };
  networking.firewall.allowedTCPPorts = [ 8090 ];
}
