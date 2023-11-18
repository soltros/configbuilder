{ config, pkgs, lib, ... }:

{
  # System configuration
  services = {

    # Docker configuration
    docker = {
      enable = true;
      # Additional Docker configurations can be added here
    };

    # Plex Media Server configuration
    plex = {
      enable = true;
      openFirewall = true;
      # Customize Plex settings as needed
    };

    # Add other common server services as required:
    # Nginx or Apache for web serving, Samba for file sharing,
    # Postfix for a mail server, Syncthing for file synchronization, etc.

    # Example: Nginx
    nginx = {
      enable = true;
      # Nginx specific configurations
    };

    # Example: Samba
    samba = {
      enable = true;
      # Samba specific configurations
    };

    # ... Add any other services you need ...
  };

  # User management (if needed)
  users.users = {
    # Define your users and their settings here
  };

  # Any additional system-wide settings can be configured here
}
