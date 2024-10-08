{ config, pkgs, ... }:

{
  # Enable PipeWire
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Uncomment to enable JACK support
    # jack.enable = true;
  };
}
