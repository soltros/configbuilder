{ config, pkgs, lib, ... }:

with lib;

let
  webdavUser = "webdavuser";
  webdavGroup = "webdavgroup";
  webdavRoot = "/var/www/webdav";
  webdavPort = 8080;
  webdavConfigFile = "/etc/webdav-server.toml";  # Custom config file path
  webdavPassword = "YourDesiredPasswordHere";  # Replace with your password
in {
  users.users.${webdavUser} = {
    isNormalUser = true;
    home = webdavRoot;
    extraGroups = [ webdavGroup ];
    uid = lib.mkForce 1001; # Ensure this value is enforced
  };

  users.groups.${webdavGroup} = {
    gid = lib.mkForce 1001; # Ensure this value is enforced
  };

  services.webdav-server-rs = {
    enable = true;
    configFile = webdavConfigFile;  # Use custom config file
  };

  system.activationScripts.webdav = ''
    mkdir -p ${webdavRoot}
    chown ${webdavUser}:${webdavGroup} ${webdavRoot}

    # Create the config file manually
    cat > ${webdavConfigFile} << EOF
[server]
listen = ["0.0.0.0:${toString webdavPort}"]

[accounts]
auth-type = "htpasswd.default"

[htpasswd.default]
htpasswd = "/etc/webdav.htpasswd"

[[location]]
route = ["/"]
directory = "${webdavRoot}"
handler = "filesystem"
methods = ["webdav-rw"]
autoindex = true
auth = "true"
EOF

    # Generate htpasswd file
    if [ ! -f /etc/webdav.htpasswd ]; then
      echo "${webdavUser}:$(openssl passwd -apr1 ${webdavPassword})" > /etc/webdav.htpasswd
    fi
  '';
}
