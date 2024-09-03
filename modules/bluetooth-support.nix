{ config, pkgs, ... }:

{
   hardware.bluetooth.enable = true; # enables support for Bluetooth
   hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot
   # services.blueman.enable = true; - enable if your desktop doesn't support built-in Bluetooth.
}

