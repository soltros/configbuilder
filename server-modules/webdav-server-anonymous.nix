{ config, pkgs, lib, ... }:

with lib;

let
  webdavRoot = "/var/www/webdav";
  webdavPort = 8080;
  webdavConfigFile = "/etc/webdav-server.toml";  # Custom config file path
in {
  # Define the WebDAV server service
  services.webdav-server-rs = {
    enable = true;
    configFile = webdavConfigFile;  # Use custom config file
  };

  # Create the activation script for the WebDAV server
  system.activationScripts.webdav = ''
    mkdir -p ${webdavRoot}

    # Create the config file manually
    cat > ${webdavConfigFile} << EOF
[server]
addr = "0.0.0.0"
port = ${toString webdavPort}

[location]
route = "/"
allow = ["0.0.0.0/0"]

[auth]
enabled = false

[security]
allow_anonymous = true
EOF
  '';
}
