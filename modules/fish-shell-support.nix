{ config, pkgs, ... }:

{
  # Fish Shell support.
    users.users.derrik.shell = pkgs.fish;
    programs.fish.enable = true;

}

