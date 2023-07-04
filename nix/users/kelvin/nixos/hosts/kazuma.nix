{ inputs, pkgs, ... }:

let
  username = "kelvin";
in {

  config = {
    users.users."${username}" = {
      isNormalUser = true;
      description = "Kelvin";
      extraGroups = [ "wheel" "networkmanager" "audio" "podman" ];
      # shell = pkgs.zsh;
      packages = [ pkgs.git ];
    };

    programs.zsh.enable = true;

    home-manager.extraSpecialArgs = { inherit inputs; };
    home-manager.users."${username}" = { pkgs, config, lib, ... }: {
      imports = [
        ../../hm/common.nix
      ];

      home.stateVersion = "22.11";
    };
  };

}
