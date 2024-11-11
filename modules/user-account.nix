{ config, pkgs, ... }:

{
 # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.derrik = {
    isNormalUser = true;
    description = "Derrik Diener";
    extraGroups = [ "networkmanager" "wheel" "gamemode"];
  };
}
