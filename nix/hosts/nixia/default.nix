{ lib, config, pkgs, ... }:

{
  imports = [ ../common.nix ./hardware-configuration.nix ];

  config = {
    k.name = "nixia";
    k.kind = "pc";

    system.stateVersion = "22.11";

    k.modules.audio-prod.enable = true;

    services.smokeping = {
      enable = true;
      targetConfig = ''
        probe = FPing
        menu = Top
        title = Network Latency Grapher
        remark = Welcome to the SmokePing website of Kelvin's Network.

        + Local
        menu = Local
        title = Local Network
        ++ LocalMachine
        menu = Local Machine
        title = This host
        host = localhost
        
        + DNS
        ++ Cloudflare_DNS_1
        host = 1.1.1.1
        ++ Cloudflare_DNS_2
        host = 1.0.0.1
        ++ Google_DNS_1
        host = 8.8.8.8
        ++ Google_DNS_2
        host = 8.4.4.8
        
        + Sites
        ++ Google
        host = google.com
      '';
    };

    modules.graphical.enable = true;

    modules.services.syncthing.enable = true;
    # modules.services.n8n.enable = true;

    # Hardware
    modules.radeon.enable = true;
    
    environment.systemPackages = with pkgs; [
      steam
    ];

    # Bootloader
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot/efi";
  };
}