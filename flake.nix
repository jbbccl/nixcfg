{
  description = "Optimized NixOS Flake Configuration";

  inputs = {
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";

    nixpkgs.follows = "nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fcitx5-vinput = {
      url = "github:xifan2333/fcitx5-vinput";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia-greeter = {
      url = "github:noctalia-dev/noctalia-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hermes-agent = {
      url = "github:NousResearch/hermes-agent";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    username = "e";
    system = "x86_64-linux";

    lib = import ./lib {inherit inputs system;};

    mkSystem = {
      hostName,
      extraModules ? [],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;

        specialArgs = {
          inherit self inputs username hostName;
        };

        modules =
          [
            ./host/${hostName}/configuration.nix
            inputs.home-manager.nixosModules.home-manager
            {
              system.stateVersion = "25.11";
              nixpkgs.overlays = lib.nixpkgsOverlays;
              home-manager.backupFileExtension = "backup";
              home-manager.startAsUserService = true;
              home-manager.users.${username}.home.stateVersion = "26.05";
            }
            inputs.sops-nix.nixosModules.sops
            inputs.noctalia.nixosModules.default
            inputs.noctalia-greeter.nixosModules.default
            inputs.hermes-agent.nixosModules.default
            inputs.mango.nixosModules.mango
            inputs.stylix.nixosModules.stylix
          ]
          ++ extraModules;
      };
  in {
    # ── NixOS configurations ────────────────────────────────────
    nixosConfigurations = {
      lap = mkSystem {
        hostName = "lap";
        extraModules = [];
      };

      pc = mkSystem {
        hostName = "pc";
        extraModules = [];
      };

      install-iso = import ./lib/install-iso.nix {
        inherit self inputs system;
        cfgLib = lib;
      };
    };
  };
}
