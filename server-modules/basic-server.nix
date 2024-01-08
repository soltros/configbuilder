{ config, pkgs, lib, ... }:

{
  # System configuration
  services = {
    # Nginx Web Server
    nginx = {
      enable = true;
      # Nginx specific configurations
    };

    # Samba File Sharing
    samba = {
      enable = true;
      # Samba specific configurations
    };

    # OpenSSH Server for secure remote access
    openssh = {
      enable = true;
      # SSH specific configurations
    };

    # PostgreSQL Database Server
    postgresql = {
      enable = true;
      # PostgreSQL specific configurations
    };

    # Docker Container Management
    docker = {
      enable = true;
      # Docker specific configurations
    };

    # Logrotate for log management
    logrotate = {
      enable = true;
      # Logrotate specific configurations
    };

    # Dovecot IMAP Server
    dovecot = {
      enable = true;
      # Dovecot specific configurations
    };

    # Cron for scheduled tasks
    cron = {
      enable = true;
      # Cron specific configurations
    };

    # Syncthing for file synchronization
    syncthing = {
      enable = true;
      # Syncthing specific configurations
    };

    # BorgBackup for backups
    borgbackup = {
      enable = true;
      # BorgBackup specific configurations
    };

    # Firewall Configuration
    firewall = {
      enable = true;
      # Firewall rules and configurations
    };

    # Apache Web Server (optional alternative to Nginx)
    httpd = {
      enable = false; # Set to true if you want to use Apache
      # Apache specific configurations
    };

    # ... Add any other services you need ...
  };

  # User management (if needed)
  users.users = {
    # Define your users and their settings here
  };

  # System-wide package installation
  environment.systemPackages = with pkgs; [
    htop   # For system monitoring
    nmon   # Another system monitoring tool
    # other useful packages
  ];

  # Any additional system-wide settings can be configured here
}
