{ config, pkgs, ... }:

{
  # Enable Docker
  virtualisation.docker.enable = true;

  # Optional: Specify Docker storage driver, e.g., for btrfs filesystem
  # virtualisation.docker.storageDriver = "btrfs";

  # Optional: Enable rootless mode for Docker
  # virtualisation.docker.rootless = {
  #   enable = true;
  #   setSocketVariable = true;
  # };

  # Add users to the Docker group for socket access
  # Replace '<myuser>' with your actual user name
  users.users.derrik.extraGroups = [ "docker" ];
  # Or alternatively, add users like this:
  # users.extraGroups.docker.members = [ "username-with-access-to-socket" ];
}
