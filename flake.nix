{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let
      supportedPlatforms = [ "aarch64-linux" "x86_64-linux" ];
      forAllPlatforms = nixpkgs.lib.genAttrs supportedPlatforms;

      nixosModules = import ./nix/modules;
      userModules = import ./nix/users;

      allNixosModules = builtins.attrValues nixosModules;
      allUserModules = builtins.attrValues userModules;

      mkSystem = args@{ hostPlatform ? "x86_64-linux", pkgs ? nixpkgs
        , extraModules ? [ ], ... }:
        nixpkgs.lib.nixosSystem (args // {
          modules = [ inputs.home-manager.nixosModules.home-manager ]
            ++ allNixosModules ++ allUserModules ++ extraModules;
          specialArgs = { inherit inputs; };
        });

      lib = import ./nix/lib { inherit inputs; };

      hostConfigs = import ./nix/hosts;
    in
    rec {
      inherit nixosModules;

      # Export custom packages
      packages = forAllPlatforms (system:
        lib.filterSupportedPkgs system
          (import ./nix/pkgs {
            pkgs = import nixpkgs {
              inherit system;
              overlays = [ ];
              config.allowUnfree = true;
            };
          })
      );

      nixosConfigurations = {
        nixia = mkSystem { extraModules = [ hostConfigs.nixia ]; };
        kazuma = mkSystem { extraModules = [ hostConfigs.kazuma ]; };
        ryuko = mkSystem { extraModules = [ hostConfigs.ryuko-wsl ]; };
      };

      # TODO: home / profile configurarions

      checks = forAllPlatforms (platform:
        let
          inherit (nixpkgs.lib.attrsets) filterAttrs mapAttrs;
          # checkPackages = packages.${platform};
          checkHosts = mapAttrs (_name: host: host.config.system.build.toplevel)
            (filterAttrs (_name: host: host.pkgs.hostPlatform == platform)
              nixosConfigurations);
          # checkUsers = mapAttrs (_name: user: user.activationPackage)
          #   (filterAttrs (_name: user: user.pkgs.system == system) homeConfigurations);
        in { }
        # // checkPackages
        // checkHosts
        # // checkUsers
      );

    };
}
