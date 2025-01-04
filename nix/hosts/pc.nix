{ config, lib, pkgs, ... }:

{
  config = lib.mkIf (config.k.host.tags.pc) {

    ## Gnome Keyring
    #services.gnome.gnome-keyring.enable = true;

    # Sound with PipeWire
    #hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      #jack.enable = true;
    };

    # Printer services
    services.printing.enable = true;

    environment.systemPackages = [
      pkgs.ntfs3g
    ];
  };
}
